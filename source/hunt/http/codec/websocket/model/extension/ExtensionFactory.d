module hunt.http.codec.websocket.model.extension.ExtensionFactory;

import hunt.http.codec.websocket.model.extension.AbstractExtension;

import hunt.http.codec.websocket.model.Extension;
import hunt.http.codec.websocket.model.ExtensionConfig;
import hunt.http.codec.websocket.model.extension.compress.DeflateFrameExtension;
import hunt.http.codec.websocket.model.extension.compress.PerMessageDeflateExtension;
import hunt.http.codec.websocket.model.extension.compress.XWebkitDeflateFrameExtension;
import hunt.http.codec.websocket.model.extension.fragment.FragmentExtension;
import hunt.http.codec.websocket.model.extension.identity.IdentityExtension;

import hunt.collection.Map;
import hunt.collection.HashMap;
import hunt.logging;
import hunt.Exceptions;


abstract class ExtensionFactory  { // : Iterable<Class<? : Extension>>
    private Map!(string, AbstractExtension) availableExtensions;

    this() {
        availableExtensions = new HashMap!(string, AbstractExtension)();
        // implementationMissing(false);
        // TODO: Tasks pending completion -@zxp at 11/13/2018, 3:18:21 PM
        // 
        // for (Extension ext : extensionLoader) {
        //     if (ext !is null) {
        //         availableExtensions.put(ext.getName(), ext.getClass());
        //     }
        // }
        // if (CollectionUtils.isEmpty(availableExtensions)) {
        //     availableExtensions.put(new DeflateFrameExtension().getName(), DeflateFrameExtension.class);
        //     availableExtensions.put(new PerMessageDeflateExtension().getName(), PerMessageDeflateExtension.class);
        //     availableExtensions.put(new XWebkitDeflateFrameExtension().getName(), XWebkitDeflateFrameExtension.class);
        //     availableExtensions.put(new IdentityExtension().getName(), IdentityExtension.class);
        //     availableExtensions.put(new FragmentExtension().getName(), FragmentExtension.class);
        // }
    }

    // Map<string, Class<? : Extension>> getAvailableExtensions() {
    //     return availableExtensions;
    // }

    // Class<? : Extension> getExtension(string name) {
    //     return availableExtensions.get(name);
    // }

    // Set<string> getExtensionNames() {
    //     return availableExtensions.keySet();
    // }

    bool isAvailable(string name) {
        tracef("Extension: %s", name);
        return availableExtensions.containsKey(name);
    }

    // override
    // Iterator<Class<? : Extension>> iterator() {
    //     return availableExtensions.values().iterator();
    // }

    abstract Extension newInstance(ExtensionConfig config);

    // void register(string name, Class<? : Extension> extension) {
    //     availableExtensions.put(name, extension);
    // }

    // void unregister(string name) {
    //     availableExtensions.remove(name);
    // }
}
