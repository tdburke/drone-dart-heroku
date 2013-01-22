// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library server;

import "dart:io";
import "dart:utf";

const HOST = "0.0.0.0";

const LOG_REQUESTS = true;

const _CLIENT_FILES = "web/client";


void main() {
  HttpServer server = new HttpServer();
  server.addRequestHandler((HttpRequest request) => true, requestReceivedHandler);
  
  // Heroku will set the PORT value
  var port = int.parse(Platform.environment['PORT']);
  
  // Server needs to listen on 0.0.0.0:PORT
  server.listen(HOST, port);
  
  print("Server running on http://${HOST}:${port}.");
}


// These helper methods are based on code from github.com/nfrancois/dartdelivery
// Check it out for a more complete example.  This is a work in progress.
_serveFile(File file, OutputStream outputStream){
  file.openInputStream().pipe(outputStream);  
}

void requestReceivedHandler(HttpRequest request, HttpResponse response) {
 
  var fileName = request.path;
  var file = new File(_CLIENT_FILES.concat(fileName));
  
  file.exists().then((exist) {
    if(exist){
      _serveFile(file, response.outputStream);
      return;
    } else {
      //response.statusCode = HttpStatus.NOT_FOUND;
      // TODO: Reply with a nice error page
    } 
  });
 


}

String createHtmlResponse() {
  return
'''
<html>
  <style>
    body { background-color: teal; }
    p { background-color: white; border-radius: 8px; border:solid 1px #555; text-align: center; padding: 0.5em;
        font-family: "Lucida Grande", Tahoma; font-size: 18px; color: #555; }
  </style>
  <body>
    <br/><br/>
    <p>Current time: ${new Date.now()}</p>
  </body>
</html>
''';
}

/*
_errorPage(int error, OutputStream outputStream){
  File errorPage = new File(_ERRORS_FILES.concat(error.toString()).concat(_HTML_EXTENSION));
  _serveFile(errorPage, outputStream);
}
*/

