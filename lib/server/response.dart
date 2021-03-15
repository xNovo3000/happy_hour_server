import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

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
		// get the response
		HttpResponse response = request.response;
		// set the ok code
		response.statusCode = 200;
		// remove all the useless headers
		response.headers.clear();
		// set the content type
		if (contentType != null) {
			response.headers.contentType = contentType;
		}
		// add the custom headers
		headers.forEach((key, value) => response.headers.add(key, value));
		// write the body
		if (body != null) {
			if (contentType == jsonContent) {
				body = json.encode(body);
			} else if (contentType == jpegContent && body is Uint8List) {
				body = base64.encode(body);
			}
			response.write(body);
		}
		// close
		return response.close();
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
		// get the response
		HttpResponse response = request.response;
		// set the ok code
		response.statusCode = statusCode;
		// remove all the useless headers
		response.headers.clear();
		// add the custom headers
		headers.forEach((key, value) => response.headers.add(key, value));
		// write the body
		if (body != null) {
			response.write(body);
		}
		// close
		return response.close();
	}

}