module hunt.http.codec.http.stream.DataFrameHandler;

import hunt.http.codec.http.stream.HttpHandler;
import hunt.http.codec.http.stream.HttpConnection;
import hunt.http.codec.http.stream.HttpOutputStream;

import hunt.http.codec.http.frame.DataFrame;
import hunt.http.codec.http.model.MetaData;
import hunt.util.Common;

/**
 * 
 */
abstract class DataFrameHandler {

    static void handleDataFrame(DataFrame dataFrame, Callback callback,
                                 HttpRequest request, HttpResponse response,
                                 HttpOutputStream output, HttpConnection connection,
                                 HttpHandler httpHandler) {
        try {
            httpHandler.content(dataFrame.getData(), request, response, output, connection);
            if (dataFrame.isEndStream()) {
                httpHandler.contentComplete(request, response, output, connection);
                httpHandler.messageComplete(request, response, output, connection);
            }
            callback.succeeded();
        } catch (Exception t) {
            callback.failed(t);
        }
    }
}
