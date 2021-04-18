import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:happy_hour_server/server/logger.dart';

abstract class Response {

	const Response._();

	static final ContentType jsonContent = ContentType('application', 'json', charset: 'utf-8');
	static final ContentType jpegContent = ContentType('image', 'jpeg', charset: 'base64');

	static Future ok(HttpRequest request, {
		ContentType? contentType,
		Object? body = null,
		Map<String, dynamic> headers = const <String, dynamic>{},
	}) {
		// clear the session because the session is used as a 'container'
		request.session.clear();
		// set the ok code
		request.response.statusCode = 200;
		// remove all the useless headers
		_injectCorsHeaders(request);
		// set the content type
		if (contentType != null) {
			request.response.headers.contentType = contentType;
		}
		// add the custom headers
		headers.forEach((key, value) => request.response.headers.add(key, value));
		// write the body
		if (body != null) {
			if (contentType == jsonContent) {
				body = json.encode(body);
			} else if (contentType == jpegContent && body is Uint8List) {
				body = base64.encode(body);
			}
			request.response.write(body);
		}
		// print the request
		_printDebugData(request);
		// close
		return request.response.close();
	}

	static Future accepted(HttpRequest request) {
		// clear the session because the session is used as a 'container'
		request.session.clear();
		// set the ok code
		request.response.statusCode = 202;
		// set cors headers
		_injectCorsHeaders(request);
		// print the request
		_printDebugData(request);
		// return
		return request.response.close();
	}

	static Future noContent(HttpRequest request, {Map<String, dynamic> headers = const <String, dynamic>{}}) =>
		Response._error(request, statusCode: HttpStatus.noContent, headers: headers);

	static Future badRequest(HttpRequest request, {Map<String, dynamic> headers = const <String, dynamic>{}}) =>
		Response._error(request, statusCode: HttpStatus.badRequest, headers: headers);

	static Future unauthorized(HttpRequest request, {Map<String, dynamic> headers = const <String, dynamic>{}}) =>
		Response._error(request, statusCode: HttpStatus.unauthorized, headers: headers);

	static Future forbidden(HttpRequest request, {Map<String, dynamic> headers = const <String, dynamic>{}}) =>
		Response._error(request, statusCode: HttpStatus.forbidden, headers: headers);

	static Future internalServerError(HttpRequest request, {Map<String, dynamic> headers = const <String, dynamic>{}}) =>
		Response._error(request, statusCode: HttpStatus.internalServerError, headers: headers);

	static Future notImplemented(HttpRequest request, {Map<String, dynamic> headers = const <String, dynamic>{}}) =>
		Response._error(request, statusCode: HttpStatus.notImplemented, headers: headers);

	static Future _error(HttpRequest request, {
		int statusCode = HttpStatus.notFound,
		Object? body = null,
		Map<String, dynamic> headers = const <String, dynamic>{},
	}) {
		// clear the session because the session is used as a 'container'
		request.session.clear();
		// set the ok code
		request.response.statusCode = statusCode;
		// remove all the useless headers
		_injectCorsHeaders(request);
		// add the custom headers
		headers.forEach((key, value) => request.response.headers.add(key, value));
		// write the body
		if (body != null) {
			request.response.write(body);
		}
		// print the request
		_printDebugData(request);
		// close
		return request.response.close();
	}

	static void _injectCorsHeaders(HttpRequest request) {
		request.response.headers.add('Access-Control-Allow-Origin', request.headers['origin'] ?? '*');
		request.response.headers.add('Access-Control-Allow-Methods', <String>['HEAD', 'GET', 'POST', 'PATCH', 'DELETE']);
		request.response.headers.add('Access-Control-Allow-Headers', <String>['Authorization', 'Content-Type', 'Access-Control-Allow-Origin']);
		request.response.headers.add('Access-Control-Expose-Headers', 'Authorization');
		request.response.headers.add('Access-Control-Max-Age', 1728000);
		request.response.headers.add('Access-Control-Allow-Credentials', true);
	}

	static void _printDebugData(HttpRequest request) {
		Logger.i('Method: ${request.method} - Uri: ${request.uri} - Response status code: ${request.response.statusCode}');
	}

}