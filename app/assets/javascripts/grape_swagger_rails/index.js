"use strict";
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
var COPY_BUTTON_LABEL = "Copy to clipboard";
var labelCopyButtons = function (root) {
    var targets = root instanceof Element && root.matches(".copy-to-clipboard")
        ? __spreadArray([root], Array.from(root.querySelectorAll(".copy-to-clipboard")), true) : Array.from(root.querySelectorAll(".copy-to-clipboard"));
    targets.forEach(function (node) {
        var el = node;
        if (!el.getAttribute("title")) {
            el.setAttribute("title", COPY_BUTTON_LABEL);
        }
        if (!el.getAttribute("aria-label")) {
            el.setAttribute("aria-label", COPY_BUTTON_LABEL);
        }
    });
};
var safeDecodeURIComponent = function (value) {
    try {
        return decodeURIComponent(value);
    }
    catch (_a) {
        return value;
    }
};
var initializeSwaggerPage = function () {
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
    var getTheme = function () {
        return options.theme === "dark" ? "dark" : "light";
    };
    var applyTheme = function (theme) {
        root.dataset.theme = theme;
        root.classList.toggle("dark-mode", theme === "dark");
        if (!themeToggle) {
            return;
        }
        themeToggle.textContent = theme === "dark" ? "Light Mode" : "Dark Mode";
        themeToggle.setAttribute("aria-pressed", String(theme === "dark"));
    };
    var getApiKeyValue = function () {
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
    };
    var ensureRequestHeaders = function (request) {
        if (!request.headers) {
            request.headers = {};
        }
        return request.headers;
    };
    var setRequestHeader = function (request, key, value) {
        var headers = ensureRequestHeaders(request);
        if (headers instanceof Headers) {
            headers.set(key, value);
            return;
        }
        headers[key] = value;
    };
    var absoluteSpecUrl = function (url) {
        if (!url) {
            return "";
        }
        if (/^https?:\/\//.test(url)) {
            return url;
        }
        return options.app_url + url;
    };
    var normalizeSwaggerUrls = function () {
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
    };
    var selectedSwaggerUrl = function (urls) {
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
    };
    var setupSpecSelector = function (urls, selectedUrl) {
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
    };
    var hideInfoUrlPlugin = function () {
        return {
            wrapComponents: {
                InfoUrl: function () { return function () { return null; }; },
            },
        };
    };
    var hideDocVersionPlugin = function () {
        return {
            wrapComponents: {
                VersionStamp: function () { return function () { return null; }; },
            },
        };
    };
    var hideVersionStampPlugin = function () {
        return {
            wrapComponents: {
                OpenAPIVersion: function () { return function () { return null; }; },
            },
        };
    };
    // Swagger UI's "Clear" button (next to Execute) is confusing — it resets
    // the internal request / response state but does not clear values still visible
    // in the rendered input fields. Upstream issue swagger-api/swagger-ui#5283
    // has acknowledged the UX problem since 2019 without a fix. Hide by default.
    var hideClearButtonPlugin = function () {
        return {
            wrapComponents: {
                clear: function () { return function () { return null; }; },
            },
        };
    };
    var buildPlugins = function () {
        var configuredPlugins = options.swagger_ui_config && options.swagger_ui_config.plugins;
        var plugins = Array.isArray(configuredPlugins) ? configuredPlugins.slice() : [];
        var displayDefaults = {
            api_key_input: true,
            info_url: true,
            doc_version: true,
            version_stamp: true,
            clear_button: false,
        };
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
        if (!display.clear_button) {
            plugins.push(hideClearButtonPlugin);
        }
        return plugins;
    };
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
    // Swagger UI's `.copy-to-clipboard` elements (the icon next to
    // operation paths, cURL examples, OAuth redirect URLs, etc.) ship without
    // a `title` or `aria-label` in some renderings, so on hover users see no
    // tooltip and screen readers announce nothing. Label any unlabeled
    // instances as Swagger UI renders or re-renders the tree.
    labelCopyButtons(document.body);
    var container = document.getElementById("swagger-ui-container");
    if (container) {
        new MutationObserver(function (mutations) {
            mutations.forEach(function (mutation) {
                mutation.addedNodes.forEach(function (node) {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        labelCopyButtons(node);
                    }
                });
            });
        }).observe(container, { childList: true, subtree: true });
    }
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
    //
    // NOTE: We intentionally do NOT use `layoutActions.parseDeepLinkHash()` here.
    // That method is Swagger UI's built-in deep linking plugin action, designed to
    // run during initial spec load (inside the `onComplete` callback). When called
    // after spec rendering is complete, it fails to expand operations — likely
    // because it depends on internal state or lifecycle context that no longer applies.
    //
    // Instead, we directly call `layoutActions.show()` which reliably toggles the
    // visibility of tags/operations, then scroll into view manually.
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
        var tag = safeDecodeURIComponent(parts[0]);
        var operationId = parts.length > 1 ? safeDecodeURIComponent(parts[1]) : null;
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
};
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initializeSwaggerPage);
}
else {
    initializeSwaggerPage();
}
