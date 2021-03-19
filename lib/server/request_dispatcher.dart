import 'dart:io';

import 'package:happy_hour_server/server/response.dart';

abstract class RequestDispatcher {

	// [TODO]: MAYBE INSERT FILTERS FOR EACH REQUEST (?)
	Future handle(HttpRequest request) {
		switch (request.method) {
			case 'GET': return doGet(request);
			case 'POST': return doPost(request);
			case 'HEAD': return doHead(request);
			case 'PATCH': return doPatch(request);
			case 'DELETE': return doDelete(request);
			case 'OPTIONS': return doOptions(request);
			default: return Response.notImplemented(request);
		}
	}

	Future doHead(HttpRequest request) => Response.notImplemented(request);
	Future doGet(HttpRequest request) => Response.notImplemented(request);
	Future doPost(HttpRequest request) => Response.notImplemented(request);
	Future doPatch(HttpRequest request) => Response.notImplemented(request);
	Future doDelete(HttpRequest request) => Response.notImplemented(request);
	Future doOptions(HttpRequest request) => Response.accepted(request);

}