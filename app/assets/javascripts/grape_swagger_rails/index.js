"use strict";
function initializeSwaggerPage() {
    var optionsElement = document.documentElement.dataset.swaggerOptions;
    if (!optionsElement ||
        typeof SwaggerUIBundle === "undefined" ||
        typeof SwaggerUIStandalonePreset === "undefined") {
        return;
    }
    var options = JSON.parse(optionsElement);
    var authInput = document.getElementById("input_apiKey");
    var specSelector = document.getElementById("spec-selector");
    var specSelectorWrapper = document.getElementById("spec-selector-wrapper");
    var themeToggle = document.getElementById("theme-toggle");
    var root = document.documentElement;
    function getTheme() {
        return options.theme === "dark" ? "dark" : "light";
    }
    function applyTheme(theme) {
        root.dataset.theme = theme;
        root.classList.toggle("dark-mode", theme === "dark");
        if (!themeToggle) {
            return;
        }
        themeToggle.textContent = theme === "dark" ? "Light Mode" : "Dark Mode";
        themeToggle.setAttribute("aria-pressed", String(theme === "dark"));
    }
    function getApiKeyValue() {
        if (!authInput) {
            return "";
        }
        var key = authInput.value ? authInput.value.trim() : "";
        if (!key) {
            return "";
        }
        if (options.api_auth === "basic") {
            return "Basic " + btoa(key);
        }
        if (options.api_auth === "bearer") {
            return "Bearer " + key;
        }
        if (options.api_auth === "token") {
            return "Token token=\"".concat(key, "\"");
        }
        return key;
    }
    function ensureRequestHeaders(request) {
        if (!request.headers) {
            request.headers = {};
        }
        return request.headers;
    }
    function setRequestHeader(request, key, value) {
        var headers = ensureRequestHeaders(request);
        if (headers instanceof Headers) {
            headers.set(key, value);
            return;
        }
        headers[key] = value;
    }
    function absoluteSpecUrl(url) {
        if (!url) {
            return "";
        }
        if (/^https?:\/\//.test(url)) {
            return url;
        }
        return options.app_url + url;
    }
    function normalizeSwaggerUrls() {
        if (!Array.isArray(options.urls)) {
            return [];
        }
        return options.urls
            .map(function (entry, index) {
            if (typeof entry === "string") {
                return { name: entry, url: absoluteSpecUrl(entry), default: false };
            }
            return {
                name: entry.name || entry.url || "Spec " + (index + 1),
                url: absoluteSpecUrl(entry.url),
                default: Boolean(entry.default),
            };
        })
            .filter(function (entry) { return Boolean(entry.url); });
    }
    function selectedSwaggerUrl(urls) {
        if (!urls.length) {
            return null;
        }
        for (var i = 0; i < urls.length; i += 1) {
            if (urls[i].default) {
                return urls[i];
            }
        }
        if (options.url) {
            var absoluteUrl = absoluteSpecUrl(options.url);
            for (var j = 0; j < urls.length; j += 1) {
                if (urls[j].url === absoluteUrl) {
                    return urls[j];
                }
            }
        }
        return urls[0];
    }
    function setupSpecSelector(urls, selectedUrl) {
        if (!specSelector || !specSelectorWrapper || urls.length < 2) {
            return;
        }
        urls.forEach(function (entry) {
            var option = document.createElement("option");
            option.value = entry.url;
            option.textContent = entry.name;
            if (selectedUrl && entry.url === selectedUrl.url) {
                option.selected = true;
            }
            specSelector.appendChild(option);
        });
        specSelectorWrapper.hidden = false;
    }
    function hideInfoUrlPlugin() {
        return {
            wrapComponents: {
                InfoUrl: function () { return function () { return null; }; },
            },
        };
    }
    function hideDocVersionPlugin() {
        return {
            wrapComponents: {
                VersionStamp: function () { return function () { return null; }; },
            },
        };
    }
    function hideVersionStampPlugin() {
        return {
            wrapComponents: {
                OpenAPIVersion: function () { return function () { return null; }; },
            },
        };
    }
    function buildPlugins() {
        var configuredPlugins = options.swagger_ui_config && options.swagger_ui_config.plugins;
        var plugins = Array.isArray(configuredPlugins) ? configuredPlugins.slice() : [];
        var displayDefaults = { api_key_input: true, info_url: true, doc_version: true, version_stamp: true };
        var display = Object.assign({}, displayDefaults, options.display || {});
        if (!display.info_url) {
            plugins.push(hideInfoUrlPlugin);
        }
        if (!display.doc_version) {
            plugins.push(hideDocVersionPlugin);
        }
        if (!display.version_stamp) {
            plugins.push(hideVersionStampPlugin);
        }
        return plugins;
    }
    applyTheme(getTheme());
    if (themeToggle) {
        themeToggle.addEventListener("click", function () {
            options.theme = root.dataset.theme === "dark" ? "light" : "dark";
            applyTheme(options.theme);
        });
    }
    var swaggerUrls = normalizeSwaggerUrls();
    var selectedUrl = selectedSwaggerUrl(swaggerUrls);
    var bundleConfig = Object.assign({}, options.swagger_ui_config || {}, {
        dom_id: "#swagger-ui-container",
        deepLinking: true,
        docExpansion: options.doc_expansion,
        supportedSubmitMethods: options.supported_submit_methods || [],
        validatorUrl: options.validator_url,
        layout: "BaseLayout",
        presets: [SwaggerUIBundle.presets.apis, SwaggerUIStandalonePreset],
        plugins: buildPlugins(),
        requestInterceptor: function (request) {
            var headers = options.headers || {};
            Object.keys(headers).forEach(function (key) {
                setRequestHeader(request, key, headers[key]);
            });
            var apiKeyValue = getApiKeyValue();
            if (!apiKeyValue) {
                return request;
            }
            if (options.api_key_type === "query") {
                var separator = request.url.indexOf("?") === -1 ? "?" : "&";
                request.url +=
                    separator +
                        encodeURIComponent(options.api_key_name) +
                        "=" +
                        encodeURIComponent(apiKeyValue);
                return request;
            }
            setRequestHeader(request, options.api_key_name, apiKeyValue);
            return request;
        },
    });
    if (swaggerUrls.length) {
        bundleConfig.urls = swaggerUrls;
        if (selectedUrl) {
            bundleConfig["urls.primaryName"] = selectedUrl.name;
        }
    }
    else {
        bundleConfig.url = absoluteSpecUrl(options.url);
    }
    window.ui = SwaggerUIBundle(bundleConfig);
    if (selectedUrl) {
        window.ui.specActions.updateUrl(selectedUrl.url);
        window.ui.specActions.download(selectedUrl.url);
    }
    setupSpecSelector(swaggerUrls, selectedUrl);
    if (specSelector && swaggerUrls.length > 1) {
        specSelector.addEventListener("change", function (event) {
            var target = event.target;
            var url = target.value;
            window.ui.specActions.updateUrl(url);
            window.ui.specActions.download(url);
        });
    }
    // Listen for hash changes so that navigating to a deep-link URL in the same
    // tab (e.g. pasting a copied operation URL into the address bar) expands the
    // target operation without requiring a full page refresh.
    window.addEventListener("hashchange", function () {
        var hash = window.location.hash;
        if (!hash || hash === "#") {
            return;
        }
        // Hash format used by Swagger UI deep linking: #/tag/operationId
        var parts = hash.replace(/^#\/?/, "").split("/").filter(Boolean);
        if (parts.length === 0) {
            return;
        }
        var tag = decodeURIComponent(parts[0]);
        var operationId = parts.length > 1 ? decodeURIComponent(parts[1]) : null;
        window.ui.layoutActions.show(["operations-tag", tag], true);
        if (operationId) {
            window.ui.layoutActions.show(["operations", tag, operationId], true);
        }
        // Scroll to the expanded element. Swagger UI uses id="operations-{tag}-{operationId}"
        // for operations and id="operations-tag-{tag}" for tag sections. Use a small delay
        // to allow the DOM to update after the layout action.
        var targetId = operationId
            ? "operations-" + tag + "-" + operationId
            : "operations-tag-" + tag;
        requestAnimationFrame(function () {
            var element = document.getElementById(targetId);
            if (element) {
                element.scrollIntoView({ behavior: "smooth", block: "start" });
            }
        });
    });
}
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initializeSwaggerPage);
}
else {
    initializeSwaggerPage();
}
