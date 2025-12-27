#!/usr/bin/env bash
set -euo pipefail

container="remnawave-subscription-page"
assets_dir="frontend/assets"
container_html_path="/opt/app/frontend/index.html"

js_file="$(docker exec -i "$container" sh -lc "ls -1 ${assets_dir} | grep -E '^index-.*\\.js$' | head -n 1")"
css_file="$(docker exec -i "$container" sh -lc "ls -1 ${assets_dir} | grep -E '^index-.*\\.css$' | head -n 1")"

if [[ -z "$js_file" || -z "$css_file" ]]; then
  echo "Не найдены index-*.js или index-*.css в контейнере ${container}:${assets_dir}" >&2
  exit 1
fi

js_path="/assets/${js_file}"
css_path="/assets/${css_file}"

tmp_file="$(mktemp)"

cat > "$tmp_file" <<'HTML'
<!doctype html>
<html lang="en" dir="ltr">
    <head>
        <meta charset="UTF-8" />
        <meta name="robots" content="noindex, nofollow" />
        <meta name="color-scheme" content="dark only" />
        <meta name="theme-color" content="#161B23" />
        <meta
            name="viewport"
            content="minimum-scale=1, initial-scale=1, width=device-width, user-scalable=no"
        />
        <link rel="icon" type="image/svg+xml" href="/assets/favicon.svg" />
        <link rel="icon" sizes="32x32" type="image/png" href="/assets/favicon-32x32.png" />
        <link rel="icon" sizes="16x16" type="image/png" href="/assets/favicon-16x16.png" />
        <link rel="apple-touch-icon" sizes="180x180" href="/assets/favicon-180x180.png" />

        <link rel="preconnect" crossorigin="anonymous" href="https://fonts.googleapis.com" />
        <link rel="preconnect" crossorigin="anonymous" href="https://fonts.gstatic.com" />

        <link
            href="https://fonts.googleapis.com/css2?family=Fira+Mono:wght@400;500;700&family=Montserrat:ital,wght@0,100..900;1,100..900&family=Unbounded:wght@200..900&display=swap"
            rel="stylesheet"
        />
        <link
            href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@100..900&display=swap"
            rel="stylesheet"
        />
        <link
            href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@100..900&display=swap"
            rel="stylesheet"
        />
        <link rel="stylesheet" href="__CSS__" />

        <meta name="description" content="<%- metaDescription %>" />
        <title><%- metaTitle %></title>
        <style>
            #snow {
                position: fixed;
                inset: 0;
                pointer-events: none;
                overflow: hidden;
                z-index: 9999;
            }
            #snow .flake {
                position: absolute;
                top: -10vh;
                color: rgba(255, 255, 255, 0.9);
                font-size: var(--size);
                opacity: var(--opacity);
                animation:
                    snow-fall var(--fall) linear infinite,
                    snow-sway var(--sway) ease-in-out infinite;
            }
            #snow .flake.dot {
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 50%;
                color: transparent;
            }
            @keyframes snow-fall {
                to {
                    transform: translateY(120vh);
                }
            }
            @keyframes snow-sway {
                0%,
                100% {
                    margin-left: 0;
                }
                50% {
                    margin-left: var(--drift);
                }
            }
            @media (prefers-reduced-motion: reduce) {
                #snow .flake {
                    animation: none;
                }
            }
        </style>
    </head>
    <body>
        <div id="snow" aria-hidden="true"></div>
        <div id="root"></div>
        <script type="module" src="__JS__"></script>

        <div id="sbpg" data-panel="<%- panelData %>"></div>
        <script>
            (() => {
                const container = document.getElementById('snow');
                if (!container) return;

                const count = Math.min(80, Math.max(30, Math.floor(window.innerWidth / 20)));

                const shapes = ['❄', '❅', '✻', '✼'];

                for (let i = 0; i < count; i += 1) {
                    const flake = document.createElement('div');
                    const isDot = Math.random() < 0.45;
                    flake.className = `flake ${isDot ? 'dot' : 'shape'}`;
                    flake.textContent = isDot
                        ? ''
                        : shapes[Math.floor(Math.random() * shapes.length)];

                    const size = (Math.random() * (isDot ? 6 : 14) + (isDot ? 3 : 8)).toFixed(2);
                    const fall = (Math.random() * 10 + 8).toFixed(2);
                    const sway = (Math.random() * 6 + 3).toFixed(2);
                    const delay = (Math.random() * -20).toFixed(2);
                    const opacity = (Math.random() * 0.5 + 0.3).toFixed(2);
                    const drift = (Math.random() * 60 - 30).toFixed(2);

                    flake.style.setProperty('--size', `${size}px`);
                    flake.style.setProperty('--fall', `${fall}s`);
                    flake.style.setProperty('--sway', `${sway}s`);
                    flake.style.setProperty('--opacity', opacity);
                    flake.style.setProperty('--drift', `${drift}px`);
                    flake.style.left = `${Math.random() * 100}vw`;
                    flake.style.animationDelay = `${delay}s`;
                    if (isDot) {
                        flake.style.width = `${size}px`;
                        flake.style.height = `${size}px`;
                    }

                    container.appendChild(flake);
                }
            })();
        </script>
    </body>
</html>
HTML

sed -E -i \
  -e "s|__CSS__|${css_path}|g" \
  -e "s|__JS__|${js_path}|g" \
  "$tmp_file"

docker cp "$tmp_file" "${container}:${container_html_path}"
rm -f "$tmp_file"

docker restart ${container}

echo "OK: ${container}:${container_html_path} обновлен"


