module hunt.http.server.http.router.HTTPSession;

import hunt.container.HashMap;
import hunt.container.Map;

import hunt.util.datetime;
import hunt.util.exception;
import std.datetime;


/**
 * 
 */
class HTTPSession  { // : Serializable

    private string id;
    private long creationTime;
    private long lastAccessedTime;
    private int maxInactiveInterval;
    private Map!(string, Object) attributes;
    private bool newSession;

    string getId() {
        return id;
    }

    void setId(string id) {
        this.id = id;
    }

    long getCreationTime() {
        return creationTime;
    }

    void setCreationTime(long creationTime) {
        this.creationTime = creationTime;
    }

    long getLastAccessedTime() {
        return lastAccessedTime;
    }

    void setLastAccessedTime(long lastAccessedTime) {
        this.lastAccessedTime = lastAccessedTime;
    }

    /**
     * Get the max inactive interval. The time unit is second.
     *
     * @return The max inactive interval.
     */
    int getMaxInactiveInterval() {
        return maxInactiveInterval;
    }

    /**
     * Set the max inactive interval. The time unit is second.
     *
     * @param maxInactiveInterval The max inactive interval.
     */
    void setMaxInactiveInterval(int maxInactiveInterval) {
        this.maxInactiveInterval = maxInactiveInterval;
    }

    Map!(string, Object) getAttributes() {
        return attributes;
    }

    void setAttributes(Map!(string, Object) attributes) {
        this.attributes = attributes;
    }

    bool isNewSession() {
        return newSession;
    }

    void setNewSession(bool newSession) {
        this.newSession = newSession;
    }

    bool isInvalid() {
        long currentTime = convert!(TimeUnits.HectoNanosecond, TimeUnits.Millisecond)(Clock.currStdTime);
        return (currentTime - lastAccessedTime) > (maxInactiveInterval * 1000);
    }

    static HTTPSession create(string id, int maxInactiveInterval) {
        long currentTime = convert!(TimeUnits.HectoNanosecond, TimeUnits.Millisecond)(Clock.currStdTime);
        HTTPSession session = new HTTPSession();
        session.setId(id);
        session.setMaxInactiveInterval(maxInactiveInterval);
        session.setCreationTime(currentTime);
        session.setLastAccessedTime(session.getCreationTime());
        session.setAttributes(new HashMap!(string, Object)());
        session.setNewSession(true);
        return session;
    }

    override
    bool opEquals(Object o) {
        if (this is o) return true;
        if (o is null || typeid(this) != typeid(o)) return false;
        HTTPSession that = cast(HTTPSession) o;
        return id == that.id;
    }

    override
    size_t toHash() @trusted nothrow {
        return hashOf(id);
    }
}




/**
 * 
 */
class SessionInvalidException : RuntimeException {
    this() {
        super("");
    }

    this(string msg) {
        super(msg);
    }
}

/**
 * 
 */
class SessionNotFound : RuntimeException {
    this() {
        super("");
    }

    this(string msg) {
        super(msg);
    }
}
