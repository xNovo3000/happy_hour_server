import 'dart:io';

import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

import '../filters/v2/logged.dart';

class ApiV2 extends RequestDispatcher {

	final RequestFilter logged = FilterLoggedV2();

	@override
	Future doHead(HttpRequest request) {
		// logged required
		if (!logged.doFilter(request)) {
			return logged.onError(request);
		}
		// credentials ok
		return Response.ok(request);
	}

}