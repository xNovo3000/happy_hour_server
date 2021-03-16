import 'dart:io';

import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

class ApiV1 extends RequestDispatcher {

	@override
	Future doHead(HttpRequest request) => Response.ok(request);

}