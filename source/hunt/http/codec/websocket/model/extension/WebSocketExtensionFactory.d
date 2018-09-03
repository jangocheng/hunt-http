module hunt.http.codec.websocket.model.extension;

import hunt.http.codec.websocket.exception.WebSocketException;
import hunt.http.codec.websocket.model.Extension;
import hunt.http.codec.websocket.model.ExtensionConfig;
import hunt.http.utils.StringUtils;

import std.array;

class WebSocketExtensionFactory : ExtensionFactory {

    override
    Extension newInstance(ExtensionConfig config) {
        if (config is null) {
            return null;
        }

        string name = config.getName();
        if (!name.empty()) {
            return null;
        }

        Class<? : Extension> extClass = getExtension(name);
        if (extClass is null) {
            return null;
        }

        try {
            return extClass.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            throw new WebSocketException("Cannot instantiate extension: " ~ extClass, e);
        }
    }
}