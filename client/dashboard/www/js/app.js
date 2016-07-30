var __API_URL__, __rights, __uptime;

__API_URL__ = "http://picstreet-staging.eu-west-1.elasticbeanstalk.com";

if (window.location.href.match('localhost')) {
  __API_URL__ = "http://localhost:3000";
}

console.log("%c[Pixer API] : " + __API_URL__, 'color: green;');

__rights = {
  everyone: 0,
  guest: 1,
  member: 2,
  admin: 3
};

__uptime = moment();

angular.module('picstreet', ['ngResource', 'ngCordova', 'ngStorage', 'ionic', 'ionic-native-transitions', 'lbServices', 'ngPicstreet', 'ngIOS9UIWebViewPatch', 'picstreet.translate', 'picstreet.directives', 'picstreet.authenticated', 'picstreet.unauthenticated']).config(function($ionicNativeTransitionsProvider, $ionicConfigProvider, $urlRouterProvider, LoopBackResourceProvider, $httpProvider) {
  $ionicConfigProvider.views.swipeBackEnabled(false);
  $ionicNativeTransitionsProvider.setDefaultOptions({
    duration: 400,
    slowdownfactor: 4,
    iosdelay: -1,
    androiddelay: -1,
    winphonedelay: -1,
    fixedPixelsTop: 0,
    fixedPixelsBottom: 0,
    triggerTransitionEvent: '$ionicView.afterEnter',
    backInOppositeDirection: false
  });
  $ionicNativeTransitionsProvider.setDefaultTransition({
    type: 'slide',
    direction: 'left'
  });
  $ionicNativeTransitionsProvider.setDefaultBackTransition({
    type: 'slide',
    direction: 'right'
  });
  $urlRouterProvider.otherwise('/login');
  LoopBackResourceProvider.setAuthHeader('X-Access-Token');
  LoopBackResourceProvider.setUrlBase(__API_URL__ + "/api");
  $httpProvider.defaults.useXDomain = true;
  return delete $httpProvider.defaults.headers.common['X-Requested-With'];
}).run(function($connect, $ionicHistory, $ionicNativeTransitions, $rootScope, $state, $ionicPlatform, $cordovaStatusbar, $cordovaDialogs, $filter) {
  $connect.remember(function(me) {
    console.log('REMEMBER ME', me);
    if (me) {
      if ($state.current.name === 'login') {
        return $state.go('authenticated.map');
      }
    } else {
      return $state.go('login');
    }
  });
  $ionicPlatform.ready(function() {
    document.addEventListener("pause", function() {
      return console.log('pause');
    });
    return document.addEventListener("resume", function() {
      console.log('resume');
      return __uptime = moment();
    });
  });
  return $ionicPlatform.ready(function() {
    if (window.cordova) {
      $cordovaStatusbar.styleColor('white');
      if (window.cordova.plugins.Keyboard) {
        return cordova.plugins.Keyboard.disableScroll(true);
      }
    }
  });
});

angular.module('picstreet.directives', []);

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('picstreet.translate', ['pascalprecht.translate']).config(function($translateProvider) {
  $translateProvider.useStaticFilesLoader({
    prefix: 'i18n/locale-',
    suffix: '.json'
  });
  $translateProvider.determinePreferredLanguage(function() {
    var availables, lang, nav;
    availables = ['en'];
    nav = window.navigator;
    lang = nav.language || nav.browserLanguage || nav.systemLanguage || nav.userLanguage;
    if (lang) {
      lang = lang.split('-')[0];
      if (indexOf.call(availables, lang) < 0) {
        lang = void 0;
      }
    }
    if (!lang) {
      lang = availables[0];
    }
    return lang;
  });
  $translateProvider.fallbackLanguage('en');
});

angular.module('picstreet').service('$connect', function(LoopBackAuth, Photographer, $rootScope) {
  var $connect;
  return $connect = {
    signup: function(me, opts, callback) {
      if (opts == null) {
        opts = {};
      }
      return Photographer.create(me).$promise.then(callback)["catch"](function(err) {
        return console.log('err : ', err);
      });
    },
    login: function(opts, callback) {
      if (opts == null) {
        opts = {};
      }
      if (callback == null) {
        callback = function() {};
      }
      return Photographer.login({
        email: opts.email,
        password: opts.password,
        rememberMe: true
      }).$promise.then(function(accessToken) {
        LoopBackAuth.setUser(accessToken.id, accessToken.userId, accessToken.user);
        LoopBackAuth.rememberMe = true;
        LoopBackAuth.save();
        return callback(accessToken);
      })["catch"](function(err) {
        return callback(false);
      });
    },
    logout: function(callback) {
      Photographer.logout();
      callback();
      return $rootScope.$emit('$unauthenticated');
    },
    remember: function(callback) {
      if (callback == null) {
        callback = function() {};
      }
      if (window.localStorage.getItem('$LoopBack$accessTokenId')) {
        return Photographer.getCurrent({
          filter: {
            include: ['roles', 'albums']
          }
        }).$promise.then(function(me) {
          $rootScope.me = me;
          $rootScope.$emit('$authenticated', me);
          return callback(me);
        })["catch"](function(err) {
          return callback(false);
        });
      } else {
        return callback(false);
      }
    }
  };
});



angular.module('picstreet').service('$pxModal', function($rootScope, $ionicModal, $controller) {
  var $bbModal;
  return $bbModal = {
    getPaymentMethods: function(bindScope, callback) {
      if (bindScope == null) {
        bindScope = {};
      }
      if (callback == null) {
        callback = function() {};
      }
      return $bbModal.getModal({
        name: 'PaymentMethods',
        templateUrl: 'payment.view.html',
        controller: 'paymentCtrl',
        bindScope: bindScope
      }, function(modal, modalScope) {
        modalScope.isModal = true;
        modalScope.selectCreditCard = function(card) {
          $rootScope.$broadcast('$card:update', card);
          return modalScope.modal.hide();
        };
        return callback(modal, modalScope);
      });
    },
    getMyPictures: function(bindScope, callback) {
      if (bindScope == null) {
        bindScope = {};
      }
      if (callback == null) {
        callback = function() {};
      }
      return $bbModal.getModal({
        name: 'MyPictures',
        templateUrl: 'pictures.view.html',
        controller: 'picturesCtrl',
        bindScope: bindScope
      }, function(modal, modalScope) {
        modalScope.isModal = true;
        modalScope.selectCreditCard = function(card) {
          $rootScope.$broadcast('$card:update', card);
          return modalScope.modal.hide();
        };
        return callback(modal, modalScope);
      });
    },
    getModal: function(opts, callback) {
      var modalScope, propertyName, propertyValue, ref;
      if (callback == null) {
        callback = function() {};
      }
      if (opts.templateUrl === void 0) {
        return callback(new Error("opts.templateUrl is undefined"));
      }
      modalScope = $rootScope.$new();
      if (Object.keys(opts.bindScope).length) {
        ref = opts.bindScope;
        for (propertyName in ref) {
          propertyValue = ref[propertyName];
          modalScope[propertyName] = propertyValue;
        }
      }
      if (opts.controller) {
        $controller(opts.controller, {
          $scope: modalScope
        });
      }
      return $ionicModal.fromTemplateUrl(opts.templateUrl, {
        scope: modalScope,
        animation: opts.animation || 'slide-in-up'
      }).then(function(modal) {
        modalScope.modal = modal;
        modalScope.show = function() {
          modal.show();
          return console.log("$bb:modal:" + (opts.name || 'x') + ":show");
        };
        modalScope.hide = function(state) {
          if (state == null) {
            state = void 0;
          }
          modal.hide();
          return console.log("$bb:modal:" + (opts.name || 'x') + ":hide");
        };
        return callback(modal, modalScope);
      });
    }
  };
});



angular.module('ngIOS9UIWebViewPatch', ['ng']).config([
  '$provide', function($provide) {
    'use strict';
    $provide.decorator('$browser', [
      '$delegate', '$window', function($delegate, $window) {
        var applyIOS9Shim, isIOS9UIWebView;
        isIOS9UIWebView = function(userAgent) {
          return /(iPhone|iPad|iPod).* OS 9_\d/.test(userAgent) && !/Version\/9\./.test(userAgent);
        };
        applyIOS9Shim = function(browser) {
          var clearPendingLocationUrl, originalUrlFn, pendingLocationUrl;
          pendingLocationUrl = null;
          originalUrlFn = browser.url;
          clearPendingLocationUrl = function() {
            pendingLocationUrl = null;
          };
          browser.url = function() {
            if (arguments.length) {
              pendingLocationUrl = arguments[0];
              return originalUrlFn.apply(browser, arguments);
            }
            return pendingLocationUrl || originalUrlFn.apply(browser, arguments);
          };
          window.addEventListener('popstate', clearPendingLocationUrl, false);
          window.addEventListener('hashchange', clearPendingLocationUrl, false);
          return browser;
        };
        if (isIOS9UIWebView($window.navigator.userAgent)) {
          return applyIOS9Shim($delegate);
        }
        return $delegate;
      }
    ]);
  }
]);

String.prototype.camelCaseToDash = function() {
  return this.replace(/([A-Z])/g, function($1) {
    return "-" + $1.toLowerCase();
  });
};

String.prototype.capitalize = function() {
  return "" + (this.charAt(0).toUpperCase()) + (this.slice(1));
};

Array.prototype.rotate = function(newfirstItem) {
  var first, last, newFirstIndex;
  newFirstIndex = this.indexOf(newfirstItem);
  first = this.slice(newFirstIndex);
  last = this.slice(0, newFirstIndex);
  return first.concat(last);
};

angular.module('picstreet').factory('$socket', function(LoopBackAuth) {
  var id, socket, userId;
  console.log('$socket');
  id = LoopBackAuth.accessTokenId;
  userId = LoopBackAuth.currentUserId;
  socket = io.connect(__API_URL__);
  socket.emit('login', {
    id: id,
    userId: userId
  });
  socket.on('authenticated', function(data) {});
  return socket;
});



angular.module('picstreet.authenticated', ['picstreet.map', 'picstreet.payment', 'picstreet.customers', 'picstreet.customer', 'picstreet.photographers', 'picstreet.albums', 'picstreet.album']).config(function($stateProvider) {
  return $stateProvider.state('authenticated', {
    abstract: true,
    templateUrl: 'authenticated.view.html',
    controller: "authenticatedCtrl"
  });
});

angular.module('picstreet.authenticated').controller('authenticatedCtrl', function($rootScope, $scope, $state, $connect, $pxModal) {
  $scope.api = __API_URL__;
  $scope.logout = function() {
    return $connect.logout(function() {
      return $state.go('login');
    });
  };
  $scope.openModalPaymentMethods = function() {
    return $pxModal.getPaymentMethods({}, function(modal, modalScope) {
      return modalScope.show();
    });
  };
  return $scope.openModalMyPictures = function() {
    return $pxModal.getMyPictures({}, function(modal, modalScope) {
      return modalScope.show();
    });
  };
});

angular.module('picstreet.unauthenticated', ['picstreet.login', 'picstreet.signup']);

angular.module("picstreet.album", ['ngDropzone']).config(function($stateProvider) {
  $stateProvider.state('authenticated.album', {
    url: '/album/:id',
    views: {
      menuContent: {
        templateUrl: 'album.view.html',
        controller: 'albumCtrl'
      }
    },
    resolve: {
      album: function(Album, $stateParams) {
        return Album.findOne({
          filter: {
            where: {
              id: $stateParams.id
            },
            include: 'pictures'
          }
        });
      }
    }
  });
}).run(function() {});

angular.module("picstreet.album").controller("albumCtrl", function($rootScope, $scope, Album, Picture, album) {
  $scope.dropzone = {};
  $scope.newPictures = {};
  console.log($scope.album = album);
  $scope.updateAlbum = function(album) {
    return Album.upsert(album).$promise.then(function(success) {
      return console.log('success : ', success);
    })["catch"](function(err) {
      return console.log('err : ', err);
    });
  };
  $scope.dropzoneConfig = {
    parallelUploads: 1,
    maxFileSize: 30000000000,
    autoDiscover: false,
    renameFilename: function(filename) {
      var newfilename, picture;
      console.log('RENAME FILE config : ', filename);
      newfilename = $scope.album.id + '-' + new Date().getTime() + '.jpg';
      picture = {
        name: newfilename,
        albumId: $scope.album.id
      };
      console.log('PICTURE : ', picture);
      $scope.newPictures[filename] = picture;
      return newfilename;
    },
    url: 'http://localhost:3000/api/Buckets/ppxpictures/upload'
  };
  return $scope.dropzoneEvents = {
    addedfile: function(file) {
      return console.log(file);
    },
    success: function(file) {},
    error: function(file, error) {
      return console.log(file, error);
    },
    totaluploadprogress: function(a, b, c) {
      return console.log(a, b, c);
    },
    queuecomplete: function() {
      var key, picture, pictures, ref;
      console.log('upload finish');
      console.log('create pictures');
      pictures = [];
      ref = $scope.newPictures;
      for (key in ref) {
        picture = ref[key];
        pictures.push(picture);
      }
      if (!$scope.$$phase) {
        $scope.$apply;
      }
      console.log('FUTURE PICTURES : ', pictures);
      return Picture.createMany(pictures).$promise.then(function(pictures) {
        var i, len;
        console.log('pictures : ', pictures);
        for (i = 0, len = pictures.length; i < len; i++) {
          picture = pictures[i];
          $scope.album.pictures.push(picture);
        }
        $scope.newPictures = [];
        return $scope.dropzone = void 0;
      })["catch"](function(err) {
        return console.log('err : ', err);
      });
    }
  };
});

angular.module("picstreet.albums", []).config(function($stateProvider) {
  $stateProvider.state('authenticated.albums', {
    url: '/albums',
    views: {
      menuContent: {
        templateUrl: 'albums.view.html',
        controller: 'albumsCtrl'
      }
    },
    resolve: {
      albums: function(Album) {
        return Album.find({
          filter: {
            include: [
              {
                relation: 'pictures'
              }
            ]
          }
        });
      }
    }
  });
}).run(function() {});

angular.module("picstreet.albums").controller("albumsCtrl", function(albums, $rootScope, $scope, Album) {
  var album, i, j, len, len1, picture, ref;
  for (i = 0, len = albums.length; i < len; i++) {
    album = albums[i];
    album.purchase = 0;
    console.log('album name : ', album);
    ref = album.pictures;
    for (j = 0, len1 = ref.length; j < len1; j++) {
      picture = ref[j];
      if (picture.purchase) {
        purchase += picture.price;
      }
    }
  }
  $scope.albums = albums;
  if (!$scope.$$phase) {
    $scope.$apply();
  }
  return console.log('ALBUMS PURCHASE ', $scope.albums);
});

angular.module("picstreet.customer", []).config(function($stateProvider) {
  $stateProvider.state('authenticated.customer', {
    url: '/customer/:id',
    views: {
      menuContent: {
        templateUrl: 'customer.view.html',
        controller: 'customerCtrl'
      }
    }
  });
}).run(function() {});

angular.module("picstreet.customer").controller("customerCtrl", function(LinkBetweenAlbumAndCustomer, $rootScope, $scope, $stateParams, Customer, Album) {
  Customer.findOne({
    filter: {
      where: {
        id: $stateParams.id
      },
      include: 'albums'
    }
  }).$promise.then(function(customer) {
    console.log(customer);
    return $scope.customer = customer;
  })["catch"](function(err) {
    return console.log(err);
  });
  return $scope.createAlbum = function(name, description, customer) {
    return Album.create({
      name: name,
      description: description,
      customerId: customer.id
    }).$promise.then(function(album) {
      $scope.customer.albums.push(album);
      return LinkBetweenAlbumAndCustomer.create({
        customerId: customer.id,
        albumId: album.id
      }).$promise.then(function(success) {
        return console.log('success : ', success);
      })["catch"](function(err) {
        return console.log('err : ', err);
      });
    })["catch"](function(err) {
      return console.log('err : ', err);
    });
  };
});

angular.module("picstreet.customers", []).config(function($stateProvider) {
  $stateProvider.state('authenticated.customers', {
    url: '/customers',
    views: {
      menuContent: {
        templateUrl: 'customers.view.html',
        controller: 'customersCtrl'
      }
    }
  });
}).run(function() {});

angular.module("picstreet.customers").controller("customersCtrl", function($rootScope, $scope, Customer) {
  return Customer.find({}).$promise.then(function(customers) {
    return $scope.customers = customers;
  })["catch"](function(err) {
    return console.log(err);
  });
});

angular.module("picstreet.map", ['leaflet-directive']).config(function($stateProvider) {
  $stateProvider.state('authenticated.map', {
    url: '/map',
    views: {
      'menuContent': {
        templateUrl: 'map.view.html',
        controller: 'mapCtrl'
      }
    },
    grantedRoles: ['$administrator', '$photographer', '$manager'],
    resolve: {
      photographers: function(Photographer) {
        return Photographer.find({
          filter: {
            include: {
              relation: 'positions',
              scope: {
                order: 'date DESC'
              }
            }
          }
        }).$promise;
      },
      monuments: function(Location) {
        return Location.find({}).$promise;
      }
    }
  });
}).run(function() {});

angular.module("picstreet.map").controller("mapCtrl", function($rootScope, $scope, $picstreet, photographers, monuments) {
  $scope.position = {};
  $scope.monument = {};
  $scope.loadPicture = false;
  $scope.content = 'monument';
  $scope.dropzoneConfig = {
    parallelUploads: 1,
    maxFileSize: 30000000000,
    url: 'http://localhost:3000/api/Buckets/picstreet-location/upload'
  };
  $scope.dropzoneEvents = {
    addedfile: function(file) {
      $scope.loadPicture = true;
      if (!$scope.$$phase) {
        return $scope.$apply();
      }
    },
    success: function(file) {
      $scope.monument.picture = file.name;
      if (!$scope.$$phase) {
        return $scope.$apply();
      }
    }
  };
  $scope.center = $picstreet.center;
  $scope.createMonument = function(monument) {
    $picstreet.center($scope.position, 8);
    return $picstreet.createMonumentInBdd(monument);
  };
  $scope.updateMonument = function(monument) {
    if (confirm("Are you sur to update " + monument.name + " ?")) {
      $picstreet.updateMonumentInBdd(monument);
      return $scope.monument = {};
    }
  };
  $scope.deleteMonument = function(monument) {
    if (confirm("Are you sur to delete " + monument.name + " ?")) {
      $picstreet.deleteMonumentInBdd(monument);
      return $scope.monument = {};
    }
  };
  $scope.center = $picstreet.center;
  $scope.monuments = monuments;
  $scope.photographers = photographers;
  console.info('[ PHOTOGRAPHERS ]', photographers);
  console.info('[ MONUMENTS ]', monuments);
  $scope.$on('monument:click', function(e, monument) {
    $picstreet.center(monument);
    return $scope.monument = monument;
  });
  $picstreet.init('pk.eyJ1IjoicGl4ZXI0MiIsImEiOiJjaW91cDRqaGUwMDQ5dnRramp6cGkwMWh0In0.OpoxVVl38hLmP9XG2lk26w');
  $picstreet.map = $picstreet.createMap({
    center: {
      lat: 48.8534100,
      lng: 2.3488000
    },
    zoom: 11
  });
  $picstreet.map.on('click', function(e) {
    if ($scope.content === 'monument') {
      $scope.monument.lat = e.lngLat.lat;
      $scope.monument.lng = e.lngLat.lng;
      if (!$scope.$$phase) {
        return $scope.$apply();
      }
    }
  });
  $picstreet.createPhotographers(photographers);
  $picstreet.createMonuments(monuments);
  $rootScope.$on('photographer:position:update', function(e, position) {
    return $picstreet.updatePhotographerPosition({
      photographerId: position.photographerId,
      position: position
    });
  });
});

angular.module("picstreet.payment", []).config(function($stateProvider) {
  $stateProvider.state('authenticated.payment', {
    url: '/payment',
    views: {
      menuContent: {
        templateUrl: 'payment.view.html',
        controller: 'paymentCtrl'
      }
    }
  });
}).run(function() {});

angular.module("picstreet.payment").controller("paymentCtrl", function($rootScope, $scope, $cordovaDialogs, CreditCard, $filter) {
  var createCard, scanCard, scanCardMock, scanErr, scanSuccess;
  Stripe.setPublishableKey('pk_live_uar4MHdwhBw7IJ30tnogt3xu');
  $scope.deleteCard = function(card) {
    return $cordovaDialogs.confirm($filter('translate')('deleteCreditCard'), 'Bottle Booking', ['Ok', 'Cancel']).then(function(index) {
      var button;
      button = window.cordova ? 2 : 1;
      if (index === button) {
        Action.create({
          name: 'delete:card'
        });
        $scope.cards.splice($scope.cards.indexOf(card), 1);
        return CreditCard.deleteById({
          id: card.id
        }).$promise.then(function(success) {
          return console.log('success : ', success);
        })["catch"](function(err) {
          return console.log('err : ', err);
        });
      }
    });
  };
  scanCard = function() {
    return CardIO.scan({
      collect_expiry: true,
      collect_cvv: false,
      collect_zip: false,
      shows_first_use_alert: true,
      disable_manual_entry_buttons: false
    }, scanSuccess, scanErr);
  };
  scanCardMock = function() {
    return scanSuccess({
      card_number: '4242424242424242',
      cvv: '874',
      expiry_month: 4,
      expiry_year: 2019
    });
  };
  scanErr = function(err) {
    return $scope.$emit('loading:hide', {
      force: true
    });
  };
  scanSuccess = function(scan) {
    alert('card');
    $scope.$emit('loading:unlock', {
      force: true
    });
    $scope.$emit('loading:show', {
      force: true
    });
    return Stripe.card.createToken({
      number: scan.card_number,
      cvc: scan.cvv,
      exp_month: scan.expiry_month,
      exp_year: scan.expiry_year
    }, createCard);
  };
  createCard = function(status, response) {
    console.log('STRIPE STATUS : ', status);
    console.log('STRIPE RESPONSE : ', response);
    $scope.$emit('loading:hide', {
      force: true
    });
    $scope.$emit('loading:lock', {
      force: true
    });
    return CreditCard.create({
      stripeInitialToken: response.id,
      last4: response.card.last4,
      type: response.card.type,
      expMonth: response.card.exp_month,
      expYear: response.card.exp_year,
      country: response.card.country
    }).$promise.then(function(card) {
      if (card.error) {
        return $cordovaDialogs.alert(card.error.message, 'Bottle Booking', 'Ok');
      } else {
        console.log('---------------------------------');
        console.log('- CREATE CREDIT CARD');
        console.log('---------------------------------');
        console.log('card : ', card);
        console.log('creditCards : ', $rootScope.me.creditCards);
        console.log('creditCards.length : ', $rootScope.me.creditCards.length);
        console.log('defaultcreditCards : ', $rootScope.me.defaultCreditCard);
        console.log('---------------------------------');
        $rootScope.me.creditCards.push(card);
        if (!$rootScope.me.defaultCreditCard) {
          $scope.makeDefaultCard(card);
        }
        return $rootScope.$apply();
      }
    })["catch"](function(err) {
      return console.log('err : ', err);
    });
  };
  $scope.makeDefaultCard = function(card) {
    $rootScope.me.defaultCreditCard = card;
    $rootScope.me.defaultCreditCardId = card.id;
    return Customer.prototype$updateAttributes({
      id: $rootScope.me.id
    }, {
      defaultCreditCardId: card.id
    }).$promise.then(function(err, success) {
      return console.log('default credit card success : ', err, success);
    })["catch"](function(err) {
      return console.log('err : ', err);
    });
  };
  return $scope.scanCard = function() {
    $scope.$emit('loading:show', {
      force: true
    });
    if (window.cordova) {
      scanCard();
    }
    if (!window.cordova) {
      return scanCardMock();
    }
  };
});

angular.module("picstreet.photographers", []).config(function($stateProvider) {
  $stateProvider.state('authenticated.photographers', {
    url: '/photographers',
    views: {
      menuContent: {
        templateUrl: 'photographers.view.html',
        controller: 'photographersCtrl'
      }
    },
    grantedRoles: ['$manager']
  });
}).run(function() {});

angular.module("picstreet.photographers").controller("photographersCtrl", function($rootScope, $scope, Photographer) {
  return Photographer.find({}).$promise.then(function(photographers) {
    return $scope.photographers = photographers;
  })["catch"](function(err) {
    return console.log(err);
  });
});

angular.module("picstreet.login", []).config(function($stateProvider) {
  return $stateProvider.state('login', {
    url: '/login',
    templateUrl: 'login.view.html',
    controller: 'loginCtrl'
  });
}).run(function() {});

angular.module("picstreet.login").controller("loginCtrl", function($scope, $state, $connect) {
  $scope.login = function(me) {
    return $connect.login(me, function(accessToken) {
      return $connect.remember(function(me) {
        if (me) {
          return $state.go('authenticated.map');
        }
      });
    });
  };
  return $scope.signup = function() {
    return $state.go('signup');
  };
});

angular.module("picstreet.signup", []).config(function($stateProvider) {
  $stateProvider.state('signup', {
    url: '/signup',
    templateUrl: 'signup.view.html',
    controller: 'signupCtrl'
  });
}).run(function() {});

angular.module("picstreet.signup").controller("signupCtrl", function($scope, $state, $connect) {
  $scope.signup = function(me) {
    return $connect.signup(me, {}, function(response) {
      return $state.go('authenticated.map');
    });
  };
  return $scope.back = function() {
    return $state.go('login');
  };
});
