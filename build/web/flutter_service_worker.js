'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "06bd79d0115f5c165e1df32178656f8f",
"robots.txt": "9152d7f1724ed8fbcd2e0c87029f193c",
"404.html": "a2bb81ce959d38caa08309aef339767c",
"icons/Icon-maskable-192.png": "c54902ac11b48195f5a4cbd3a5fb8eef",
"icons/Icon-maskable-512.png": "07f4d3d07b8ce7e71766b4f863d65170",
"icons/Icon-192.png": "c54902ac11b48195f5a4cbd3a5fb8eef",
"icons/Icon-512.png": "07f4d3d07b8ce7e71766b4f863d65170",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"favicon.png": "85057323903bd33326e79884dd75fa6a",
"version.json": "5dffde2e127c4ad8b9cd821465876853",
"index.html": "663ae03f5af75e415dd059d3f170af06",
"/": "663ae03f5af75e415dd059d3f170af06",
"assets/AssetManifest.json": "b9f77b353db8dcbfad34b0af9ff9d819",
"assets/AssetManifest.bin": "3af484924564ba3178611186ca233ffc",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/icons/11.png": "105137184d651b7b449bf2e4c26fbe92",
"assets/assets/icons/logo.png": "b6ef32878f2c988b19712a2c3e8151b0",
"assets/assets/icons/splashscreen.png": "2b5797a11643d9014e967bb72e24499d",
"assets/assets/icons/2-preto.png": "e622f36a5fcf2587f5d681a6eb01d4ee",
"assets/assets/icons/11-branco.png": "e6984a9787ccca2d3b54fd84cd16a03c",
"assets/assets/icons/app_icon.png": "b6ef32878f2c988b19712a2c3e8151b0",
"assets/assets/icons/2.png": "4e8530524261d9649bda182ef2f7e792",
"assets/assets/icons/logo_menudraw.png": "cab7a72161b0470c7f36ec2e06ce81f1",
"assets/assets/icons/1.png": "4ed218f228dc68671287c947f1ef015f",
"assets/assets/icons/bancos/asaas.jpg": "9bdb3bdaa0dd94e423c6e0f1d354f6d1",
"assets/assets/icons/2-branco.png": "db38c72dd38b748e370445613ddd3d09",
"assets/assets/icons/2-preto-favicon.png": "134c307614f3e3f2f734ce601b01ef42",
"assets/assets/fonts/NotoSans-Bold.ttf": "f61e5f919919a504a486c4cb17885ad4",
"assets/assets/fonts/UbuntuMono-Italic.ttf": "027c9e013a499b36e8c7f4b0f2d4f897",
"assets/assets/fonts/NotoSans-Regular.ttf": "df2c871e9eae5e1b7a0eb5d96ec5637c",
"assets/assets/fonts/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/assets/fonts/UbuntuMono-Bold.ttf": "d3e281ca75369e8517b3910bc46a7ed0",
"assets/assets/fonts/UbuntuMono-BoldItalic.ttf": "91d425ae7be0c07c93eb2fe6f08ab37e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "2a53dc403da6f1a9586c1e1bfda793c2",
"assets/FontManifest.json": "b0bef16a6513febb6ee6ba95b207b671",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/strikethrough.png": "72e2d23b4cdd8a9e5e9cadadf0f05a3f",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/underline.png": "59886133294dd6587b0beeac054b2ca3",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/highlight.png": "2aecc31aaa39ad43c978f209962a985c",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/squiggly.png": "68960bf4e16479abb83841e54e1ae6f4",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/strikethrough.png": "26f6729eee851adb4b598e3470e73983",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/underline.png": "a98ff6a28215341f764f96d627a5d0f5",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/highlight.png": "2fbda47037f7c99871891ca5e57e030b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/squiggly.png": "9894ce549037670d25d2c786036b810b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/fonts/RobotoMono-Regular.ttf": "5b04fdfec4c8c36e8ca574e40b7148bb",
"assets/packages/timezone/data/latest_all.tzf": "df0e82dd729bbaca78b2aa3fd4efd50d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/AssetManifest.bin.json": "4e6fa66fde065743e6d472b4709ad4a9",
"favicon.ico": "9dc1a83ede88d6b21b6c414030ab3328",
"firebase-messaging-sw.js": "0703f030ddd277546a8109a4352ecb5e",
"main.dart.js": "2ae7dd71897fd592ece3bc51cb9069d2",
"splash/img/light-3x.png": "1d96fcda68e30fa4d1af3552ca8803e0",
"splash/img/light-2x.png": "fa4591731fcda9cf0263f1754f293722",
"splash/img/light-background.png": "2b5797a11643d9014e967bb72e24499d",
"splash/img/dark-4x.png": "460698e94c64bfe0d67d5dca7cae8214",
"splash/img/light-4x.png": "460698e94c64bfe0d67d5dca7cae8214",
"splash/img/dark-3x.png": "1d96fcda68e30fa4d1af3552ca8803e0",
"splash/img/dark-2x.png": "fa4591731fcda9cf0263f1754f293722",
"splash/img/dark-1x.png": "e74b30ecb24e7e0839fa71503e3b7bc3",
"splash/img/light-1x.png": "e74b30ecb24e7e0839fa71503e3b7bc3",
"manifest.json": "dbd0c6741f556daaf387c2890782c1fd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
