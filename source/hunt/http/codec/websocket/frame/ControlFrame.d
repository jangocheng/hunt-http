module hunt.http.codec.websocket.frame.ControlFrame;

import hunt.http.codec.websocket.frame.WebSocketFrame;
import hunt.http.codec.websocket.exception;

import hunt.collection.BufferUtils;
import hunt.collection.ByteBuffer;

import std.conv;

abstract class ControlFrame : WebSocketFrame {
    /**
     * Maximum size of Control frame, per RFC 6455
     */
    enum int MAX_CONTROL_PAYLOAD = 125;

    this(byte opcode) {
        super(opcode);
    }

    override void assertValid() {
        if (isControlFrame()) {
            if (getPayloadLength() > ControlFrame.MAX_CONTROL_PAYLOAD) {
                throw new ProtocolException("Desired payload length [" ~ getPayloadLength().to!string() ~ 
                    "] exceeds maximum control payload length [" ~
                         MAX_CONTROL_PAYLOAD.to!string() ~ "]");
            }

            if ((finRsvOp & 0x80) == 0) {
                throw new ProtocolException("Cannot have FIN==false on Control frames");
            }

            if ((finRsvOp & 0x40) != 0) {
                throw new ProtocolException("Cannot have RSV1==true on Control frames");
            }

            if ((finRsvOp & 0x20) != 0) {
                throw new ProtocolException("Cannot have RSV2==true on Control frames");
            }

            if ((finRsvOp & 0x10) != 0) {
                throw new ProtocolException("Cannot have RSV3==true on Control frames");
            }
        }
    }

    override bool opEquals(Object obj) {   
        if (obj is null) 
            return false;

        if (this is obj) 
            return true;

        ControlFrame other = cast(ControlFrame) obj;
        if(other is null)   return false;

        if (data is null) {
            if (other.data !is null) {
                return false;
            }
        } else if (!data.opEquals(other.data)) {
            return false;
        }
        return finRsvOp == other.finRsvOp && mask == other.mask && masked == other.masked;
    }

    override bool isControlFrame() {
        return true;
    }

    override
    bool isDataFrame() {
        return false;
    }

    override
    WebSocketFrame setPayload(ByteBuffer buf) {
        if (buf !is null && buf.remaining() > MAX_CONTROL_PAYLOAD) {
            throw new ProtocolException("Control Payloads can not exceed " ~ MAX_CONTROL_PAYLOAD ~ " bytes in length.");
        }
        return super.setPayload(buf);
    }

    override
    ByteBuffer getPayload() {
        if (super.getPayload() is null) {
            return BufferUtils.EMPTY_BUFFER;
        }
        return super.getPayload();
    }
}
