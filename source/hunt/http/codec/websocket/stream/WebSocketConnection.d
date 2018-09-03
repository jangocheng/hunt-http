module hunt.http.codec.websocket.stream;

import hunt.http.codec.common.ConnectionExtInfo;
import hunt.http.codec.http2.model.MetaData;
import hunt.http.codec.websocket.model.OutgoingFrames;
import hunt.net.Connection;

import hunt.util.functional;

import hunt.container.ByteBuffer;
import java.util.concurrent.CompletableFuture;

interface WebSocketConnection : OutgoingFrames, Connection, ConnectionExtInfo {

    /**
     * Register the connection close callback.
     *
     * @param closedListener The connection close callback.
     * @return The WebSocket connection.
     */
    WebSocketConnection onClose(Action1!(WebSocketConnection) closedListener);

    /**
     * Register the exception callback.
     *
     * @param exceptionListener The exception callback.
     * @return The WebSocket connection.
     */
    WebSocketConnection onException(Action2<WebSocketConnection, Throwable> exceptionListener);

    /**
     * Get the read/write idle timeout.
     *
     * @return the idle timeout in milliseconds
     */
    long getIdleTimeout();

    /**
     * Get the IOState of the connection.
     *
     * @return the IOState of the connection.
     */
    IOState getIOState();

    /**
     * The policy that the connection is running under.
     *
     * @return the policy for the connection
     */
    WebSocketPolicy getPolicy();

    /**
     * Generate random 4bytes mask key
     *
     * @return the mask key
     */
    byte[] generateMask();

    /**
     * Send text message.
     *
     * @param text The text message.
     * @return The future result.
     */
    CompletableFuture!(bool) sendText(string text);

    /**
     * Send binary message.
     *
     * @param data The binary message.
     * @return The future result.
     */
    CompletableFuture!(bool) sendData(byte[] data);

    /**
     * Send binary message.
     *
     * @param data The binary message.
     * @return The future result.
     */
    CompletableFuture!(bool) sendData(ByteBuffer data);

    /**
     * Get the websocket upgrade request.
     *
     * @return The upgrade request.
     */
    MetaData.Request getUpgradeRequest();

    /**
     * Get the websocket upgrade response.
     *
     * @return The upgrade response.
     */
    MetaData.Response getUpgradeResponse();

}