angular.module("picstreet").run(["$templateCache", function($templateCache) {$templateCache.put("index.html","<!DOCTYPE html>\n<html>\n  <head>\n    <meta charset=\"utf-8\">\n    <meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width\">\n    <meta name=\"format-detection\" content=\"telephone=no\">\n    <title>PicStreet DASHBOARD</title>\n    <link href=\"css/app.css\" rel=\"stylesheet\">\n    <link href=\"css/picstreet.css\" rel=\"stylesheet\">\n    <link href=\"lib/ionic/css/ionic.css\" rel=\"stylesheet\">\n  </head>\n  <body ng-app=\"picstreet\" id=\"fb-root\">\n    <ion-notification menu-close></ion-notification>\n    <ion-nav-view></ion-nav-view>\n  </body>\n  <script src=\"cordova.js\"></script>\n  <script src=\"https://js.stripe.com/v2/\"></script>\n  <script src=\"static/socket.io.js\"></script>\n  <script src=\"lib/ionic/js/ionic.bundle.js\"></script>\n  <script src=\"js/vendors.js\"></script>\n  <script src=\"https://api.mapbox.com/mapbox-gl-js/v0.21.0/mapbox-gl.js\"></script>\n  <link href=\"https://api.mapbox.com/mapbox-gl-js/v0.21.0/mapbox-gl.css\" rel=\"stylesheet\">\n  <script src=\"js/api.js\"></script>\n  <script src=\"js/app.js\"></script>\n  <script src=\"js/templates.js\"></script>\n</html>");
$templateCache.put("authenticated.view.html","\n<ion-side-menus id=\"authenticated\">\n  <ion-side-menu-content drag-content=\"false\">\n    <ion-nav-view name=\"menuContent\" animation=\"no-animation\"></ion-nav-view>\n  </ion-side-menu-content>\n  <ion-side-menu side=\"left\">\n    <ion-item menu-close ui-sref=\"authenticated.map\">\n      <div class=\"icon\"><i class=\"custom-icon custom-icon-business\"></i></div>\n      <div class=\"title\">Map</div>\n    </ion-item>\n    <ion-item ui-sref=\"authenticated.photographers\" menu-close>\n      <div class=\"icon\"><i class=\"custom-icon custom-icon-business\"></i></div>\n      <div class=\"title\">Photographers</div>\n    </ion-item>\n    <ion-item ui-sref=\"authenticated.customers\" menu-close>\n      <div class=\"icon\"><i class=\"custom-icon custom-icon-business\"></i></div>\n      <div class=\"title\">Customers</div>\n    </ion-item>\n    <ion-item ui-sref=\"authenticated.albums\" menu-close>\n      <div class=\"icon\"><i class=\"custom-icon custom-icon-business\"></i></div>\n      <div class=\"title\">Albums</div>\n    </ion-item>\n    <ion-item menu-close ng-click=\"logout()\">\n      <div class=\"icon\"><i class=\"custom-icon custom-icon-business\"></i></div>\n      <div class=\"title\">Logout</div>\n    </ion-item>\n  </ion-side-menu>\n</ion-side-menus>");
$templateCache.put("login.view.html","\n<ion-view title=\"PIXER\" id=\"login\">\n  <ion-content> \n    <label class=\"item item-input\"><span class=\"input-label\">Email</span>\n      <input type=\"text\" ng-model=\"me.email\">\n    </label>\n    <label class=\"item item-input\"><span class=\"input-label\">Password</span>\n      <input type=\"password\" ng-model=\"me.password\">\n    </label>\n    <button ng-click=\"login(me)\" class=\"button button-block login\">Login</button>\n    <button ng-click=\"signup()\" class=\"button button-block signup\">Signup</button>\n  </ion-content>\n</ion-view>");
$templateCache.put("signup.view.html","\n<ion-view title=\"PIXER\" id=\"signup\">\n  <ion-content> \n    <label class=\"item item-input\"><span class=\"input-label\">Firstname</span>\n      <input type=\"text\" ng-model=\"me.firstname\">\n    </label>\n    <label class=\"item item-input\"><span class=\"input-label\">Lastname</span>\n      <input type=\"text\" ng-model=\"me.lastname\">\n    </label>\n    <label class=\"item item-input\"><span class=\"input-label\">Email</span>\n      <input type=\"text\" ng-model=\"me.email\">\n    </label>\n    <label class=\"item item-input\"><span class=\"input-label\">Password</span>\n      <input type=\"password\" ng-model=\"me.password\">\n    </label>\n    <button ng-click=\"signup(me)\" class=\"button button-block login\">Signup</button>\n    <button ng-click=\"back()\" class=\"button button-block signup\">Back</button>\n  </ion-content>\n</ion-view>");
$templateCache.put("album.view.html","\n<ion-view title=\"{{album.name}}\">\n  <ion-content id=\"album\">\n    <div class=\"infos\">\n      <input ng-model=\"album.name\">\n    </div>\n    <div class=\"album\">\n      <form id=\"dropzone\" ng-if=\"dropzone\" method=\"post\" enctype=\"multipart/form-data\" ng-dropzone dropzone=\"dropzone\" dropzone-config=\"dropzoneConfig\" event-handlers=\"dropzoneEvents\" class=\"dropzone\"></form>\n      <div ng-repeat=\"picture in album.pictures track by $index\" class=\"picture\"><img ng-src=\"http://localhost:3000/api/Buckets/ppxpicturesresized/download/resized-{{picture.name}}\">\n        <div ng-class=\"{\'purchase\': picture.purchase }\" class=\"price\">{{ picture.price }}€</div>\n      </div>\n    </div>\n    <div class=\"actions\">\n      <button ng-click=\"updateAlbum(album)\">Update Album</button>\n    </div>\n  </ion-content>\n</ion-view>");
$templateCache.put("albums.view.html","\n<ion-view title=\"Albums\">\n  <ion-content>\n    <div id=\"albums\">\n      <div ng-repeat=\"album in albums\" ui-sref=\"authenticated.album({id: album.id})\" style=\"background-image: url(\'http://localhost:3000/api/Buckets/ppxpicturesresized/download/resized-{{album.pictures[0].name}}\')\" class=\"album\"> \n        <div class=\"name\">{{ album.name }}</div>\n        <div class=\"price\">{{ album.purchase }}</div>\n      </div>\n    </div>\n  </ion-content>\n</ion-view>");
$templateCache.put("customer.view.html","\n<ion-view title=\"Customers\" id=\"customer\">\n  <div class=\"bar bar-header\">\n    <h1 class=\"title\">Customers</h1>\n  </div>\n  <ion-content class=\"customer-content\">\n    <section class=\"customer\"> \n      <ion-item class=\"name\">{{ customer.email }}</ion-item>\n    </section>\n    <section class=\"albums\">\n      <ion-item ng-repeat=\"album in customer.albums\" ui-sref=\"authenticated.album({id: album.id})\" class=\"album\">{{ album.name }}</ion-item>\n      <ion-item class=\"album\">\n        <label class=\"item item-input\"><span class=\"input-label\">Name</span>\n          <input type=\"text\" ng-model=\"name\">\n        </label>\n        <label class=\"item item-input\"><span class=\"input-label\">Description</span>\n          <input type=\"text\" ng-model=\"description\">\n        </label>\n        <button ng-click=\"createAlbum(name, description, customer)\" class=\"button button-block button-calm\">Create New Album</button>\n      </ion-item>\n    </section>\n  </ion-content>\n</ion-view>");
$templateCache.put("customers.view.html","\n<ion-view title=\"Customers\" id=\"customers\">\n  <div class=\"bar bar-header\">\n    <h1 class=\"title\">Customers</h1>\n    <button ng-click=\"modal.hide()\" class=\"button button-clear\">{{\'close\' | translate}}</button>\n  </div>\n  <ion-content class=\"customers-content\">\n    <ion-item ng-repeat=\"customer in customers\" ui-sref=\"authenticated.customer({id: customer.id})\" class=\"customer\">{{ customer.email }}</ion-item>\n  </ion-content>\n</ion-view>");
$templateCache.put("map.view.html","\n<ion-view title=\"PIXER\">\n  <div id=\"map\"></div>\n  <div menu-toggle=\"left\" class=\"picstreet-menu\"><i class=\"ion-navicon\"></i></div>\n  <div class=\"create-map-content\">\n    <div class=\"create-menu\">\n      <div ng-class=\"{\'selected\': content == \'monument\'}\" ng-click=\"content = \'monument\'\" class=\"create-menu-link\">Monument</div>\n      <div ng-class=\"{\'selected\': content == \'photographer\'}\" ng-click=\"content = \'photographer\'\" class=\"create-menu-link\">Photographer</div>\n    </div>\n    <div ng-if=\"content == \'monument\'\" class=\"create-monument\">\n      <div class=\"final\">\n        <div class=\"final-center\">\n          <div id=\"marker-monument\" ng-click=\"onClick($event)\">\n            <div id=\"item-reserve-free-shooting\"><img ng-if=\"monument.picture\" ng-src=\"{{api}}/api/Buckets/picstreet-location/download/{{monument.picture}}\">\n              <form id=\"dropzone\" ng-if=\"!monument.picture\" method=\"post\" enctype=\"multipart/form-data\" ng-dropzone dropzone=\"dropzone\" dropzone-config=\"dropzoneConfig\" event-handlers=\"dropzoneEvents\" class=\"dropzone\">\n                <div ng-show=\"!loadPicture\" class=\"dz-message\">add picture</div>\n                <div ng-show=\"loadPicture\" class=\"dz-message\">loading...</div>\n              </form>\n              <div class=\"name\">{{monument.name}}</div>\n            </div>\n            <div id=\"item-current-location-bar\"><img src=\"img/svg/location-bar.svg\"></div>\n          </div>\n        </div>\n      </div>\n      <div class=\"form\">\n        <div class=\"coord\">\n          <div class=\"lat\">\n            <input type=\"text\" ng-model=\"monument.lat\" placeholder=\"Latitude\">\n          </div>\n          <div class=\"lng\">\n            <input type=\"text\" ng-model=\"monument.lng\" placeholder=\"Longitude\">\n          </div>\n        </div>\n        <div class=\"name\">\n          <input type=\"text\" ng-model=\"monument.name\" placeholder=\"Name\">\n        </div>\n        <div class=\"description\">\n          <textarea ng-model=\"monument.description\" placeholder=\"Description\"></textarea>\n        </div>\n        <div class=\"action\">\n          <button ng-click=\"createMonument(monument)\">Create Location</button>\n          <button ng-click=\"updateMonument(monument)\">Update Location</button>\n          <button ng-click=\"deleteMonument(monument)\">Delete Location</button>\n        </div>\n      </div>\n    </div>\n    <div ng-if=\"content == \'photographer\'\" class=\"create-photographer\">\n      <h1>Photographer</h1>\n    </div>\n  </div>\n</ion-view>");
$templateCache.put("payment.view.html","\n<ion-modal-view title=\"{{ \'creditCard\' | translate }}\">\n  <ion-view title=\"{{ \'creditCard\' | translate }}\" id=\"payment\">\n    <div class=\"bar bar-header\">\n      <h1 class=\"title\">{{ \'creditCard\' | translate }}</h1>\n      <button ng-click=\"modal.hide()\" class=\"button button-clear\">{{\'close\' | translate}}</button>\n    </div>\n    <ion-content></ion-content>\n    <ion-footer-bar ng-click=\"scanCard()\" class=\"bar-dark\">\n      <div class=\"title\">{{ \'scanCreditCard\' | translate }}</div>\n    </ion-footer-bar>\n  </ion-view>\n</ion-modal-view>");
$templateCache.put("photographers.view.html","\n<ion-view title=\"Photographers\" id=\"photographers\">\n  <div class=\"bar bar-header\">\n    <h1 class=\"title\">Photographers</h1>\n    <button ng-click=\"modal.hide()\" class=\"button button-clear\">{{\'close\' | translate}}</button>\n  </div>\n  <ion-content class=\"photographers-content\">\n    <section ng-repeat=\"photographer in photographers\" class=\"photographer\">{{ photographer.email }}</section>\n  </ion-content>\n</ion-view>");}]);