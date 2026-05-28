interface Window {
  ui: any;
  grapeSwaggerRails?: {
    renderValidatorBadge: (specUrl: string) => void;
  };
}

interface SwaggerPageOptions {
  api_auth: string;
  api_key_name: string;
  api_key_type: string;
  api_key_default_value: string;
  api_key_placeholder: string;
  app_name: string;
  app_url: string;
  doc_expansion: string;
  headers: Record<string, string>;
  display: {
    api_key_input: boolean;
    info_url: boolean;
    doc_version: boolean;
    version_stamp: boolean;
    clear_button: boolean;
    validator_badge: boolean;
  };
  supported_submit_methods: string[];
  theme: string;
  url: string;
  urls: Array<string | SwaggerUrlOption> | null;
  validator_url: string | null | undefined;
  swagger_ui_config?: Record<string, unknown>;
}

interface SwaggerUrlOption {
  name?: string;
  url: string;
  default?: boolean;
}

interface NormalizedSwaggerUrl {
  name: string;
  url: string;
  default: boolean;
}

interface SwaggerRequest {
  url: string;
  headers?: Record<string, string> | Headers;
}

interface SwaggerPlugin {
  wrapComponents?: Record<string, unknown>;
}

declare const SwaggerUIBundle: any;
declare const SwaggerUIStandalonePreset: any;

const safeDecodeURIComponent = (value: string): string => {
  try {
    return decodeURIComponent(value);
  } catch {
    return value;
  }
};

const initializeSwaggerPage = (): void => {
  const optionsElement = document.documentElement.dataset.swaggerOptions;
  if (
    !optionsElement ||
    typeof SwaggerUIBundle === "undefined" ||
    typeof SwaggerUIStandalonePreset === "undefined"
  ) {
    return;
  }

  const options: SwaggerPageOptions = JSON.parse(optionsElement);
  const authInput = document.getElementById("input_apiKey") as HTMLInputElement | null;
  const specSelector = document.getElementById("spec-selector") as HTMLSelectElement | null;
  const specSelectorWrapper = document.getElementById("spec-selector-wrapper") as HTMLLabelElement | null;
  const themeToggle = document.getElementById("theme-toggle") as HTMLButtonElement | null;
  const root = document.documentElement;

  const getTheme = (): string => {
    return options.theme === "dark" ? "dark" : "light";
  };

  const applyTheme = (theme: string): void => {
    root.dataset.theme = theme;
    root.classList.toggle("dark-mode", theme === "dark");

    if (!themeToggle) {
      return;
    }

    themeToggle.textContent = theme === "dark" ? "Light Mode" : "Dark Mode";
    themeToggle.setAttribute("aria-pressed", String(theme === "dark"));
  }

  const getApiKeyValue = (): string => {
    if (!authInput) {
      return "";
    }

    const key = authInput.value ? authInput.value.trim() : "";

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
      return `Token token="${key}"`;
    }

    return key;
  }

  const ensureRequestHeaders = (request: SwaggerRequest): Record<string, string> | Headers => {
    if (!request.headers) {
      request.headers = {};
    }

    return request.headers as Record<string, string> | Headers;
  }

  const setRequestHeader = (request: SwaggerRequest, key: string, value: string): void => {
    const headers = ensureRequestHeaders(request);

    if (headers instanceof Headers) {
      headers.set(key, value);
      return;
    }

    (headers as Record<string, string>)[key] = value;
  }

  const absoluteSpecUrl = (url: string): string => {
    if (!url) {
      return "";
    }

    if (/^https?:\/\//.test(url)) {
      return url;
    }

    return options.app_url + url;
  }

  const normalizeSwaggerUrls = (): NormalizedSwaggerUrl[] => {
    if (!Array.isArray(options.urls)) {
      return [];
    }

    return options.urls
      .map((entry, index): NormalizedSwaggerUrl => {
        if (typeof entry === "string") {
          return { name: entry, url: absoluteSpecUrl(entry), default: false };
        }

        return {
          name: entry.name || entry.url || "Spec " + (index + 1),
          url: absoluteSpecUrl(entry.url),
          default: Boolean(entry.default),
        };
      })
      .filter((entry) => Boolean(entry.url));
  }

  const selectedSwaggerUrl = (urls: NormalizedSwaggerUrl[]): NormalizedSwaggerUrl | null => {
    if (!urls.length) {
      return null;
    }

    for (let i = 0; i < urls.length; i += 1) {
      if (urls[i].default) {
        return urls[i];
      }
    }

    if (options.url) {
      const absoluteUrl = absoluteSpecUrl(options.url);

      for (let j = 0; j < urls.length; j += 1) {
        if (urls[j].url === absoluteUrl) {
          return urls[j];
        }
      }
    }

    return urls[0];
  }

  const setupSpecSelector = (urls: NormalizedSwaggerUrl[], selectedUrl: NormalizedSwaggerUrl | null): void => {
    if (!specSelector || !specSelectorWrapper || urls.length < 2) {
      return;
    }

    urls.forEach((entry) => {
      const option = document.createElement("option");
      option.value = entry.url;
      option.textContent = entry.name;

      if (selectedUrl && entry.url === selectedUrl.url) {
        option.selected = true;
      }

      specSelector.appendChild(option);
    });

    specSelectorWrapper.hidden = false;
  }

  const hideInfoUrlPlugin = (): SwaggerPlugin => {
    return {
      wrapComponents: {
        InfoUrl: () => () => null,
      },
    };
  }

  const hideDocVersionPlugin = (): SwaggerPlugin => {
    return {
      wrapComponents: {
        VersionStamp: () => () => null,
      },
    };
  }

  const hideVersionStampPlugin = (): SwaggerPlugin => {
    return {
      wrapComponents: {
        OpenAPIVersion: () => () => null,
      },
    };
  }

  // Swagger UI's "Clear" button (next to Execute) is confusing — it resets
  // the internal request / response state but does not clear values still visible
  // in the rendered input fields. Upstream issue swagger-api/swagger-ui#5283
  // has acknowledged the UX problem since 2019 without a fix. Hide by default.
  const hideClearButtonPlugin = (): SwaggerPlugin => {
    return {
      wrapComponents: {
        clear: () => () => null,
      },
    };
  }

  const displayDefaults = {
    api_key_input: true,
    info_url: true,
    doc_version: true,
    version_stamp: true,
    clear_button: false,
    validator_badge: true,
  };

  const resolvedDisplay = (): typeof displayDefaults => {
    return Object.assign({}, displayDefaults, options.display || {});
  }

  const buildPlugins = (): unknown[] => {
    const configuredPlugins = options.swagger_ui_config && options.swagger_ui_config.plugins;
    const plugins = Array.isArray(configuredPlugins) ? configuredPlugins.slice() : [];
    const display = resolvedDisplay();

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
  }

  const renderValidatorBadge = (specUrl: string): void => {
    const footer = document.querySelector(".swagger-validator-footer") as HTMLElement | null;
    if (!footer) {
      return;
    }

    footer.innerHTML = "";

    const display = resolvedDisplay();
    const validatorUrl = options.validator_url;

    if (!display.validator_badge || !validatorUrl || validatorUrl === "none" || !specUrl) {
      return;
    }

    let absolute: string;
    try {
      absolute = new URL(specUrl, window.location.href).toString();
    } catch {
      return;
    }

    if (/^https?:\/\/(localhost|127\.0\.0\.1)(:|\/|$)/i.test(absolute)) {
      return;
    }

    const encoded = encodeURIComponent(absolute);
    const span = document.createElement("span");
    span.className = "float-right";

    const anchor = document.createElement("a");
    anchor.target = "_blank";
    anchor.rel = "noopener noreferrer";
    anchor.href = `${validatorUrl}/debug?url=${encoded}`;

    const img = document.createElement("img");
    img.src = `${validatorUrl}?url=${encoded}`;
    img.alt = "Online validator badge";

    anchor.appendChild(img);
    span.appendChild(anchor);
    footer.appendChild(span);
  }

  window.grapeSwaggerRails = { renderValidatorBadge };

  applyTheme(getTheme());

  if (themeToggle) {
    themeToggle.addEventListener("click", () => {
      options.theme = root.dataset.theme === "dark" ? "light" : "dark";
      applyTheme(options.theme);
    });
  }

  const swaggerUrls = normalizeSwaggerUrls();
  const selectedUrl = selectedSwaggerUrl(swaggerUrls);

  const bundleConfig = Object.assign({}, options.swagger_ui_config || {}, {
    dom_id: "#swagger-ui-container",
    deepLinking: true,
    docExpansion: options.doc_expansion,
    supportedSubmitMethods: options.supported_submit_methods || [],
    validatorUrl: options.validator_url,
    layout: "BaseLayout",
    presets: [SwaggerUIBundle.presets.apis, SwaggerUIStandalonePreset],
    plugins: buildPlugins(),
    requestInterceptor: (request: SwaggerRequest) => {
      const headers = options.headers || {};
      Object.keys(headers).forEach((key) => {
        setRequestHeader(request, key, headers[key]);
      });

      const apiKeyValue = getApiKeyValue();
      if (!apiKeyValue) {
        return request;
      }

      if (options.api_key_type === "query") {
        const separator = request.url.indexOf("?") === -1 ? "?" : "&";
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
  } else {
    bundleConfig.url = absoluteSpecUrl(options.url);
  }

  window.ui = SwaggerUIBundle(bundleConfig);

  if (selectedUrl) {
    window.ui.specActions.updateUrl(selectedUrl.url);
    window.ui.specActions.download(selectedUrl.url);
  }

  renderValidatorBadge(selectedUrl ? selectedUrl.url : absoluteSpecUrl(options.url));

  setupSpecSelector(swaggerUrls, selectedUrl);

  if (specSelector && swaggerUrls.length > 1) {
    specSelector.addEventListener("change", (event) => {
      const target = event.target as HTMLSelectElement;
      const url = target.value;
      window.ui.specActions.updateUrl(url);
      window.ui.specActions.download(url);
      renderValidatorBadge(url);
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
  window.addEventListener("hashchange", () => {
    const hash = window.location.hash;
    if (!hash || hash === "#") {
      return;
    }

    // Hash format used by Swagger UI deep linking: #/tag/operationId
    const parts = hash.replace(/^#\/?/, "").split("/").filter(Boolean);
    if (parts.length === 0) {
      return;
    }

    const tag = safeDecodeURIComponent(parts[0]);
    const operationId = parts.length > 1 ? safeDecodeURIComponent(parts[1]) : null;

    window.ui.layoutActions.show(["operations-tag", tag], true);
    if (operationId) {
      window.ui.layoutActions.show(["operations", tag, operationId], true);
    }

    // Scroll to the expanded element. Swagger UI uses id="operations-{tag}-{operationId}"
    // for operations and id="operations-tag-{tag}" for tag sections. Use a small delay
    // to allow the DOM to update after the layout action.
    const targetId = operationId
      ? "operations-" + tag + "-" + operationId
      : "operations-tag-" + tag;

    requestAnimationFrame(() => {
      const element = document.getElementById(targetId);
      if (element) {
        element.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    });
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initializeSwaggerPage);
} else {
  initializeSwaggerPage();
}
