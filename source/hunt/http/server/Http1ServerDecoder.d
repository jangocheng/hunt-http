module hunt.http.server.Http1ServerDecoder;

import hunt.http.server.Http1ServerConnection;
import hunt.http.server.Http1ServerTunnelConnection;
import hunt.http.server.Http2ServerDecoder;

import hunt.http.codec.http.decode.HttpParser;
import hunt.http.codec.websocket.decode.WebSocketDecoder;

import hunt.net.AbstractConnection;
import hunt.net.DecoderChain;
import hunt.net.ConnectionType;
import hunt.net.Session;

import hunt.collection.ByteBuffer;
import hunt.collection.BufferUtils;
import hunt.Exceptions;
import hunt.logging;
import std.conv;

/**
*/
class Http1ServerDecoder : DecoderChain {

    private WebSocketDecoder webSocketDecoder;
    private Http2ServerDecoder http2ServerDecoder;

    this(WebSocketDecoder webSocketDecoder, Http2ServerDecoder http2ServerDecoder) {
        super(null);
        this.webSocketDecoder = webSocketDecoder;
        this.http2ServerDecoder = http2ServerDecoder;
    }

    override void decode(ByteBuffer buffer, Session session) {
        ByteBuffer buf = BufferUtils.toHeapBuffer(buffer);

        Object attachment = session.getAttachment();
        version (HUNT_DEBUG)
            infof("session type: %s", typeid(attachment));

        AbstractConnection abstractConnection = cast(AbstractConnection) attachment;
        if (abstractConnection is null) {
            warningf("Bad connection instance: ", typeid(attachment));
            return;
        }

        switch (abstractConnection.getConnectionType()) {
        case ConnectionType.HTTP1: {
                Http1ServerConnection http1Connection = cast(Http1ServerConnection) attachment;
                if (http1Connection.getTunnelConnectionPromise() is null) {
                    HttpParser parser = http1Connection.getParser();
                    version (HUNT_DEBUG) trace("runing http1 parser for a buffer...");
                    while (buf.hasRemaining()) {
                        parser.parseNext(buf);
                        if (http1Connection.getUpgradeHttp2Complete()) {
                            http2ServerDecoder.decode(buf, session);
                            break;
                        } else if (http1Connection.getUpgradeWebSocketComplete()) {
                            webSocketDecoder.decode(buf, session);
                            break;
                        }
                    }
                    version (HUNT_DEBUG) trace("http1 parsing done for a buffer...");
                } else {
                    Http1ServerTunnelConnection tunnelConnection = http1Connection.createHttpTunnel();
                    if (tunnelConnection.content != null) {
                        tunnelConnection.content(buf);
                    }
                }
            }
            break;
        case ConnectionType.HTTP2: {
                http2ServerDecoder.decode(buf, session);
            }
            break;
        case ConnectionType.WEB_SOCKET: {
                webSocketDecoder.decode(buf, session);
            }
            break;
        case ConnectionType.HTTP_TUNNEL: {
                Http1ServerTunnelConnection tunnelConnection = 
                    cast(Http1ServerTunnelConnection) session.getAttachment();
                if (tunnelConnection.content != null) {
                    tunnelConnection.content(buf);
                }
            }
            break;
        default:
            throw new IllegalStateException("client does not support the protocol " ~ to!string(
                    abstractConnection.getConnectionType()));
        }
    }
}
