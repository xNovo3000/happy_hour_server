import 'dart:io';

import 'package:happy_hour_server/server/response.dart';

abstract class RequestDispatcher {

	Future doHead(HttpRequest request) => Response.notImplemented(request);
	Future doGet(HttpRequest request) => Response.notImplemented(request);
	Future doPost(HttpRequest request) => Response.notImplemented(request);
	Future doPatch(HttpRequest request) => Response.notImplemented(request);
	Future doDelete(HttpRequest request) => Response.notImplemented(request);

}