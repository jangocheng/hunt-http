module hunt.http.server.http.router.Handler;

import hunt.http.server.http.router.RoutingContext;

/**
 * 
 */
interface Handler {

    void handle(RoutingContext routingContext);

}
