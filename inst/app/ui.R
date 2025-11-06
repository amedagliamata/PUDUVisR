ui <- function() {
  page_navbar(
    id = "main_nav",
    title = div(
      style = "display: flex; align-items: center; justify-content: flex-start; font-weight: 600;",
      tags$i(class = "fas fa-bacteria", 
             style = "font-size: clamp(26px, 2.8vw, 36px); color: #10b981; margin-right: clamp(8px, 1vw, 15px); flex-shrink: 0;"),
      div(
        style = "display: flex; flex-direction: column; line-height: 1.1;",
        div(
          style = "font-size: clamp(0.9rem, 1.8vw, 1.4rem); font-weight: 800; color: #ffffff; letter-spacing: 0.5px;",
          "PUDUVisR:"
        ),
        div(
          style = "font-size: clamp(0.75rem, 1.4vw, 1.1rem); font-weight: 500; color: #ffffff; margin-top: 1px; opacity: 0.95;",
          "Pipeline for Universal Diversity Unveiling"
        )
      )
    ),
    theme = bs_theme(
      bootswatch = "flatly",
      primary = "#0000cd",
      secondary = "#64748b",
      success = "#10b981",
      info = "#64748b",
      warning = "#f59e0b",
      danger = "#ef4444",
      light = "#f8fafc",
      dark = "#0f172a",
      bg = "#ffffff",
      fg = "#1e293b"
    ),

    header = tagList(
      tags$head(

        tags$meta(name = "viewport", content = "width=device-width, initial-scale=1, shrink-to-fit=no"),
        tags$meta(`http-equiv` = "X-UA-Compatible", content = "IE=edge"),
        tags$meta(name = "format-detection", content = "telephone=no"),
        tags$meta(name = "msapplication-tap-highlight", content = "no"),
        tags$meta(name = "renderer", content = "webkit"),
        tags$meta(name = "force-rendering", content = "webkit"),
        tags$link(rel = "preload", as = "style", onload = "this.onload=null;this.rel='stylesheet'",
                  href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"),
        tags$noscript(tags$link(rel = "stylesheet", 
                               href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css")),
        tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
        tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = "anonymous"),
        tags$link(rel = "preload", as = "style", onload = "this.onload=null;this.rel='stylesheet'",
                  href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"),
        tags$noscript(tags$link(rel = "stylesheet", 
                               href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap")),
        tags$style(HTML("
          /* Global improvements with custom fonts */
          body, .navbar, .sidebar, .card {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
          }

          h1, h2, h3, h4, h5, h6, .navbar-brand {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
          }

          code, pre, .verbatim-output {
            font-family: 'JetBrains Mono', 'Courier New', monospace !important;
          }
          .navbar-brand {
            font-size: 1.5rem !important;
            font-weight: 600 !important;
          }

          /* Enhanced cards with colored borders */
          .card {
            border-radius: 12px !important;
            border: none !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08) !important;
            transition: box-shadow 0.3s ease !important;
          }

          /* Default styling for cards without specific styling */
          .card.border-0.shadow-sm {
            /* No border by default */
          }

          .card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.12) !important;
          }

          .card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%) !important;
            border-radius: 12px 12px 0 0 !important;
            border-bottom: 2px solid #e9ecef !important;
            font-weight: 600 !important;
            padding: 1rem 1.25rem !important;
          }

          /* Enhanced gradient headers for cards with colored borders */
          .bg-gradient {
            font-weight: 600 !important;
            padding: 1.25rem 1.5rem !important;
          }

          /* Enhanced buttons */
          .btn {
            border-radius: 8px !important;
            font-weight: 500 !important;
            padding: 0.5rem 1rem !important;
            transition: all 0.3s ease !important;
            border: none !important;
          }

          .btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%) !important;
            box-shadow: 0 2px 8px rgba(0,123,255,0.3) !important;
          }

          .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3 0%, #004085 100%) !important;
            transform: translateY(-1px) !important;
            box-shadow: 0 4px 12px rgba(0,123,255,0.4) !important;
          }

          .btn-darkblue {
            background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 100%) !important;
            color: white !important;
            box-shadow: 0 2px 8px rgba(30,58,138,0.3) !important;
          }

          .btn-darkblue:hover {
            background: linear-gradient(135deg, #1e40af 0%, #1d4ed8 100%) !important;
            transform: translateY(-1px) !important;
            box-shadow: 0 4px 12px rgba(30,58,138,0.4) !important;
          }

          .btn-demo {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important;
            color: white !important;
            box-shadow: 0 2px 8px rgba(16,185,129,0.3) !important;
          }

          .btn-demo:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%) !important;
            transform: translateY(-1px) !important;
            box-shadow: 0 4px 12px rgba(16,185,129,0.4) !important;
          }

          /* Responsive scale wrappers to keep content within outlines on small screens */
          .scale-on-small-container {
            position: relative;
            overflow: hidden;
            width: 100%;
          }
          .scale-on-small-content {
            transform-origin: top left;
            transition: transform 0.2s ease;
            width: 100%;
          }

          /* Progressive scaling for different screen sizes */
          @media (max-width: 1440px) {
            .scale-on-small-content { 
              transform: scale(0.92); 
              width: calc(100% / 0.92); 
            }
          }
          @media (max-width: 1366px) {
            .scale-on-small-content { 
              transform: scale(0.88); 
              width: calc(100% / 0.88); 
            }
          }
          @media (max-width: 1200px) {
            .scale-on-small-content { 
              transform: scale(0.85); 
              width: calc(100% / 0.85); 
            }
          }
          @media (max-width: 992px) {
            .scale-on-small-content { 
              transform: scale(0.8); 
              width: calc(100% / 0.8); 
            }
            /* Ensure cards don't overflow */
            .bslib-sidebar-layout .sidebar .card {
              overflow: hidden !important;
            }
          }
          @media (max-width: 768px) {
            .scale-on-small-content { 
              transform: scale(0.7); 
              width: calc(100% / 0.7); 
            }
            /* Reduce form control sizes on small screens */
            .scale-on-small-content .form-control,
            .scale-on-small-content .form-select,
            .scale-on-small-content .btn {
              font-size: 0.85rem !important;
              padding: 0.6rem 0.8rem !important;
              min-height: 40px !important;
            }
            /* More aggressive constraints for Application Information */
            .bslib-sidebar-layout .sidebar .alert {
              font-size: 0.7rem !important;
              line-height: 1.3 !important;
              padding: 0.5rem !important;
            }
            .bslib-sidebar-layout .sidebar h4 {
              font-size: 0.95rem !important;
            }
            .bslib-sidebar-layout .sidebar p {
              font-size: 0.75rem !important;
              line-height: 1.3 !important;
            }
          }
          @media (max-width: 576px) {
            .scale-on-small-content { 
              transform: scale(0.6); 
              width: calc(100% / 0.6); 
            }
            /* Further reduce sizes for very small screens */
            .scale-on-small-content .form-control,
            .scale-on-small-content .form-select,
            .scale-on-small-content .btn {
              font-size: 0.75rem !important;
              padding: 0.5rem 0.6rem !important;
              min-height: 35px !important;
            }
            .scale-on-small-content h4 {
              font-size: 1.0rem !important;
            }
            .scale-on-small-content p {
              font-size: 0.7rem !important;
            }
          }
          @media (max-width: 480px) {
            .scale-on-small-content { 
              transform: scale(0.5); 
              width: calc(100% / 0.5); 
            }
          }

          /* Ensure DataTable in scale wrapper also scales */
          .scale-on-small-content .dataTables_wrapper {
            font-size: 0.8em;
          }
          .scale-on-small-content table.dataTable {
            font-size: 0.75em;
          }

          /* Fixed GitHub footer */
          .github-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 100%);
            color: white;
            padding: 8px 15px;
            font-size: 0.85rem;
            z-index: 1000;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
            border-top: 2px solid #3b82f6;
          }
          .github-footer a {
            color: #93c5fd !important;
            text-decoration: none !important;
            font-weight: 500;
          }
          .github-footer a:hover {
            color: #dbeafe !important;
          }

          /* Add bottom padding to main content to prevent overlap with fixed footer */
          .bslib-page-navbar {
            padding-bottom: 45px;
          }

          /* Reduce navigation tab font and icon sizes */
          .navbar-nav .nav-link {
            font-size: 0.85rem !important;
            padding: 0.5rem 0.75rem !important;
          }
          .navbar-nav .nav-link i {
            font-size: 0.75rem !important;
            margin-right: 0.4rem !important;
          }
          @media (max-width: 768px) {
            .navbar-nav .nav-link {
              font-size: 0.75rem !important;
              padding: 0.4rem 0.6rem !important;
            }
            .navbar-nav .nav-link i {
              font-size: 0.7rem !important;
              margin-right: 0.3rem !important;
            }
          }

          /* Enhanced sidebar */
          .bslib-sidebar-layout > .sidebar {
            background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%) !important;
            border-radius: 12px !important;
            border: 1px solid #e9ecef !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06) !important;
          }

          /* Enhanced form controls */
          .form-control, .form-select {
            border-radius: 10px !important;
            border: 2px solid #e9ecef !important;
            transition: all 0.3s ease !important;
            padding: 1rem 1.25rem !important;
            font-size: 1rem !important;
            background-color: #ffffff !important;
            min-height: 55px !important;
            font-weight: 500 !important;
          }

          /* Fix label accessibility - ensure all labels work correctly */
          .form-label, label {
            display: block !important;
            margin-bottom: 0.5rem !important;
            font-weight: 600 !important;
          }

          /* Handle Shiny-generated form elements without explicit labels */
          .shiny-input-container:not(:has(label)) .form-control,
          .shiny-input-container:not(:has(label)) .form-select {
            margin-top: 0 !important;
          }

          .form-control:focus, .form-select:focus {
            border-color: #10b981 !important;
            box-shadow: 0 0 0 0.25rem rgba(16,185,129,0.15) !important;
            transform: translateY(-1px) !important;
          }

          .form-control:hover, .form-select:hover {
            border-color: #10b981 !important;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1) !important;
          }

          /* Enhanced file input styling */
          input[type=file] {
            padding: 0.75rem 1rem !important;
            min-height: 55px !important;
            border-radius: 10px !important;
            border: 2px solid #e9ecef !important;
            background-color: #ffffff !important;
            font-size: 1rem !important;
            font-weight: 500 !important;
            transition: all 0.3s ease !important;
            line-height: 1.5 !important;
          }

          input[type=file]:hover {
            border-color: #10b981 !important;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1) !important;
          }

          input[type=file]:focus {
            border-color: #10b981 !important;
            box-shadow: 0 0 0 0.25rem rgba(16,185,129,0.15) !important;
            outline: none !important;
          }

          /* File upload button styling - smaller and more inline */
          input[type=file]::-webkit-file-upload-button {
            background: #007bff !important;
            color: white !important;
            border: none !important;
            border-radius: 6px !important;
            padding: 0.375rem 0.75rem !important;
            font-size: 0.9rem !important;
            font-weight: 500 !important;
            margin-right: 0.5rem !important;
            cursor: pointer !important;
            transition: all 0.2s ease !important;
            height: auto !important;
            vertical-align: middle !important;
          }

          input[type=file]::-webkit-file-upload-button:hover {
            background: #0056b3 !important;
            box-shadow: 0 2px 6px rgba(0,123,255,0.3) !important;
          }

          /* Firefox file input button - smaller and more inline */
          input[type=file]::file-selector-button {
            background: #007bff !important;
            color: white !important;
            border: none !important;
            border-radius: 6px !important;
            padding: 0.375rem 0.75rem !important;
            font-size: 0.9rem !important;
            font-weight: 500 !important;
            margin-right: 0.5rem !important;
            cursor: pointer !important;
            transition: all 0.2s ease !important;
            height: auto !important;
            vertical-align: middle !important;
          }

          input[type=file]::file-selector-button:hover {
            background: #0056b3 !important;
            box-shadow: 0 2px 6px rgba(0,123,255,0.3) !important;
          }

          /* Enhanced dropdown styling */
          .selectize-input {
            border-radius: 10px !important;
            border: 2px solid #e9ecef !important;
            padding: 1rem 1.25rem !important;
            min-height: 55px !important;
            transition: all 0.3s ease !important;
            font-size: 1rem !important;
            font-weight: 500 !important;
          }

          .selectize-input:focus {
            border-color: #10b981 !important;
            box-shadow: 0 0 0 0.2rem rgba(16,185,129,0.15) !important;
          }

          /* Special styling for dropdown containers */
          .bg-light {
            background-color: #f8f9fa !important;
          }

          .form-label.fw-semibold {
            font-weight: 600 !important;
            color: #1e293b !important;
            font-size: 0.9rem !important;
            margin-bottom: 0.5rem !important;
          }

          /* Ensure dropdown visibility */
          .selectize-dropdown {
            z-index: 9999 !important;
            border: 2px solid #10b981 !important;
            border-radius: 8px !important;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15) !important;
            max-height: 300px !important;
            overflow-y: auto !important;
            position: absolute !important;
          }

          .selectize-dropdown-content {
            max-height: 280px !important;
            overflow-y: auto !important;
            padding: 0.5rem 0 !important;
          }

          .selectize-option {
            padding: 0.75rem 1rem !important;
            transition: all 0.2s ease !important;
            font-size: 1rem !important;
            border-bottom: 1px solid #f1f5f9 !important;
          }

          .selectize-option:hover {
            background-color: #f0fdf4 !important;
            color: #166534 !important;
          }

          .selectize-option.selected {
            background-color: #10b981 !important;
            color: white !important;
          }

          /* Ensure cards don't clip dropdowns */
          .card {
            overflow: visible !important;
          }

          .card-body {
            overflow: visible !important;
          }

          /* Sidebar overflow handling */
          .bslib-sidebar-layout > .sidebar {
            overflow: visible !important;
          }

          /* Enhanced tables */
          .table-container {
            border-radius: 12px !important;
            overflow: hidden !important;
            border: 1px solid #e9ecef !important;
          }

          .table {
            margin-bottom: 0 !important;
          }

          .table th {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%) !important;
            border-bottom: 2px solid #dee2e6 !important;
            font-weight: 600 !important;
            padding: 1rem 0.75rem !important;
          }

          /* Navigation improvements - Better scaling for laptop screens */
          .navbar-nav {
            margin-left: auto !important;
            margin-right: 0.5rem !important;
            padding-left: 1rem !important;
            flex-wrap: nowrap !important;
          }

          /* Responsive navbar brand area */
          .navbar-brand {
            flex: 1 !important;
            max-width: none !important;
            margin-right: 1rem !important;
            min-width: 280px !important;
            display: flex !important;
            align-items: center !important;
            height: 100% !important;
          }

          /* Ensure navbar has proper flex layout and prevents wrapping */
          .navbar > .container-fluid {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            padding-left: 0.75rem !important;
            padding-right: 0.75rem !important;
            min-height: 70px !important;
            flex-wrap: nowrap !important;
          }

          /* Ensure navbar itself centers content vertically and prevents wrapping */
          .navbar {
            align-items: center !important;
            min-height: 70px !important;
            flex-wrap: nowrap !important;
          }

          /* Push the entire nav section to the right with better spacing */
          .navbar-collapse {
            flex-grow: 0 !important;
            margin-left: auto !important;
            flex-wrap: nowrap !important;
          }

          /* Responsive adjustments for smaller laptop screens */
          @media (max-width: 1366px) and (min-width: 1024px) {
            .navbar-brand {
              min-width: 250px !important;
              margin-right: 0.5rem !important;
            }

            .navbar-nav {
              padding-left: 0.5rem !important;
            }

            .nav-link {
              padding: 0.4rem 0.7rem !important;
              font-size: 0.9rem !important;
            }
          }

          /* Adjustments for 13-inch screens (typical 1280px-1440px width) */
          @media (max-width: 1440px) and (min-width: 1200px) {
            .navbar-brand {
              min-width: 240px !important;
            }

            .nav-link {
              padding: 0.45rem 0.8rem !important;
              margin: 0 1px !important;
            }
          }

          /* Large screens and external monitors */
          @media (min-width: 1600px) {
            .navbar-brand {
              min-width: 400px !important;
              margin-right: 2rem !important;
            }

            .navbar-nav {
              padding-left: 2rem !important;
              margin-right: 1rem !important;
            }

            .nav-link {
              padding: 0.6rem 1.2rem !important;
              font-size: 1rem !important;
              margin: 0 3px !important;
            }
          }

          /* Extra large screens (4K, ultrawide) */
          @media (min-width: 2000px) {
            .navbar-brand {
              min-width: 500px !important;
              margin-right: 3rem !important;
            }

            .navbar-nav {
              padding-left: 3rem !important;
              margin-right: 1.5rem !important;
            }

            .nav-link {
              padding: 0.7rem 1.4rem !important;
              font-size: 1.1rem !important;
              margin: 0 4px !important;
            }
          }

          .nav-link {
            border-radius: 8px !important;
            margin: 0 2px !important;
            transition: all 0.3s ease !important;
            font-weight: 500 !important;
            padding: 0.5rem 1rem !important;
          }

          .nav-link:hover {
            background-color: rgba(0,123,255,0.1) !important;
            transform: translateY(-1px) !important;
          }

          .nav-link.active {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%) !important;
            box-shadow: 0 2px 8px rgba(0,123,255,0.3) !important;
            color: white !important;
          }

          /* Loading and feedback improvements */
          .alert {
            border-radius: 10px !important;
            border: none !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
          }

          /* Floating download button */
          .floating-download {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            border-radius: 50px !important;
            padding: 12px 20px !important;
            box-shadow: 0 4px 16px rgba(40,167,69,0.3) !important;
            font-weight: 600 !important;
            transition: all 0.3s ease !important;
          }

          .floating-download:hover {
            transform: translateY(-2px) scale(1.05) !important;
            box-shadow: 0 6px 20px rgba(40,167,69,0.4) !important;
          }

          /* Sidebar title styling */
          .sidebar .sidebar-title {
            font-size: 1.1rem !important;
            font-weight: 600 !important;
            color: #495057 !important;
            margin-bottom: 1rem !important;
          }

          /* Progress bar styling */
          .progress {
            height: 8px !important;
            border-radius: 10px !important;
            background-color: #f8f9fa !important;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.1) !important;
          }

          .progress-bar {
            border-radius: 10px !important;
            background: linear-gradient(90deg, #007bff 0%, #0056b3 100%) !important;
          }

          /* Table container constraints */
          .table-container table {
            width: 100% !important;
            table-layout: fixed !important;
            margin: 0 !important;
          }

          .table-container table td,
          .table-container table th {
            word-wrap: break-word !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
          }

          #uploadedFiles {
            width: 100% !important;
            margin: 0 !important;
          }

          #uploadedFiles table {
            width: 100% !important;
            table-layout: fixed !important;
            margin: 0 !important;
          }

          /* DataTable wrapper should fill available space */
          #uploadedFiles .dataTables_wrapper {
            height: 100% !important;
            display: flex !important;
            flex-direction: column !important;
          }

          #uploadedFiles .dataTables_scrollBody {
            flex: 1 !important;
            min-height: 350px !important;
          }

          /* Make the entire uploaded files card taller */
          .scale-on-small-container {
            height: 100% !important;
          }

          /* Ensure uploaded files table takes more space */
          #uploadedFiles_wrapper {
            height: 100% !important;
          }

          /* Responsive viewport-based scaling for no-scroll experience */
          .bslib-sidebar-layout {
            height: calc(100vh - 120px) !important;
            max-height: calc(100vh - 120px) !important;
            overflow: hidden !important;
            /* Fallback for RStudio viewer */
            min-height: 600px !important;
          }

          /* Specific fixes for embedded viewers (like RStudio) */
          @media screen and (max-width: 1000px) {
            .bslib-sidebar-layout {
              height: auto !important;
              max-height: none !important;
            }

            .sidebar {
              width: 100% !important;
              max-width: none !important;
            }
          }

          .bslib-sidebar-layout > .main {
            height: 100% !important;
            /* Allow scrolling so card shadows/outlines aren't clipped */
            overflow: auto !important;
          }

          .bslib-sidebar-layout > .sidebar {
            height: 100% !important;
            overflow-y: auto !important;
            overflow-x: hidden !important;
            padding: 0.75rem !important;
          }

          /* Ensure plot cards stay within viewport and show the same outline as metadata cards */
          .plot-card,
          .shared-taxa-card {
            max-height: 92vh;
          }

          /* Match metadata card outline globally (shadow-based outline) */
          .plot-card.border-0.shadow-sm,
          .shared-taxa-card.border-0.shadow-sm {
            border: none !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08) !important;
            border-radius: 12px !important;
            transition: box-shadow 0.3s ease !important;
          }

          .plot-card.border-0.shadow-sm:hover,
          .shared-taxa-card.border-0.shadow-sm:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.12) !important;
          }

          /* Sidebar card optimization for viewport fitting */
          .sidebar .card {
            margin-bottom: 0.75rem !important;
          }

          .sidebar .card:last-child {
            margin-bottom: 0 !important;
          }

          .sidebar .card-header {
            padding: 0.75rem 1rem !important;
            font-size: 0.95rem !important;
          }

          .sidebar .card-body {
            padding: 0.75rem 1rem !important;
          }

          /* Compact form controls in sidebar */
          .sidebar .form-control,
          .sidebar .form-select,
          .sidebar .selectize-input {
            min-height: 45px !important;
            padding: 0.5rem 0.75rem !important;
            font-size: 0.9rem !important;
          }

          .sidebar .btn {
            padding: 0.4rem 0.8rem !important;
            font-size: 0.9rem !important;
          }

          .sidebar .form-check {
            margin-bottom: 0.5rem !important;
          }

          .sidebar .mb-3 {
            margin-bottom: 0.75rem !important;
          }

          .sidebar .mb-4 {
            margin-bottom: 1rem !important;
          }

          /* Compact slider styling */
          .sidebar .irs {
            margin-bottom: 0.5rem !important;
          }

          /* Radio button compactness */
          .sidebar .radio {
            margin-bottom: 0.4rem !important;
          }

          /* Checkbox group compactness */
          .sidebar .checkbox {
            margin-bottom: 0.3rem !important;
          }

          /* Numeric input compactness */
          .sidebar input[type=number] {
            min-height: 40px !important;
            padding: 0.4rem 0.6rem !important;
          }

          /* All plot containers use responsive viewport-based scaling */
          .plot-container,
          .upset-plot-container {
            height: min(900px, 80vh);
            width: 100%;
            padding: 1rem;
            overflow: hidden !important;
            box-sizing: border-box !important;
          }

          /* Plotly outputs with responsive scaling */
          .plot-container .plotly,
          .plot-container .js-plotly-plot,
          .upset-plot-container .shiny-plot-output {
            height: 100% !important;
            width: 100% !important;
            max-height: 100% !important;
            max-width: 100% !important;
            overflow: hidden !important;
            transform-origin: top left;
            transition: transform 0.3s ease;
          }

          /* All plot cards with responsive heights */
          .plot-card,
          .shared-taxa-card {
            display: flex;
            flex-direction: column;
          }

          .plot-card .card-body,
          .shared-taxa-card .card-body {
            flex: 1 1 auto;
            min-height: 0; /* allow children to shrink within */
            padding: 0 !important;
            overflow: hidden !important;
            box-sizing: border-box !important;
          }

          /* 13-inch screen optimization (1280-1440px width) */
          @media screen and (max-width: 1440px) and (min-width: 1280px) {
            .plot-container,
            .upset-plot-container {
              height: min(750px, 70vh) !important;
            }
          }

          /* Smaller laptops (1000-1280px width) */
          @media screen and (max-width: 1280px) and (min-width: 1000px) {
            .plot-container,
            .upset-plot-container {
              height: min(600px, 60vh) !important;
            }
          }

          /* Small screens with true scaling (under 1000px) */
          @media screen and (max-width: 1000px) {
            .bslib-sidebar-layout {
              height: auto !important;
              max-height: none !important;
            }

            .plot-container,
            .upset-plot-container {
              height: min(400px, 50vh) !important;
              min-height: 350px !important;
              padding: 0.75rem !important;
            }

            .plot-card,
            .shared-taxa-card {
              max-height: 92vh;
            }

            /* Make plot cards have same outline as metadata cards */
            .plot-card.border-0.shadow-sm,
            .shared-taxa-card.border-0.shadow-sm {
              border-radius: 12px !important;
              border: none !important;
              box-shadow: 0 4px 12px rgba(0,0,0,0.08) !important;
              transition: box-shadow 0.3s ease !important;
            }

            .plot-card.border-0.shadow-sm:hover,
            .shared-taxa-card.border-0.shadow-sm:hover {
              box-shadow: 0 6px 20px rgba(0,0,0,0.12) !important;
            }

            .sidebar {
              width: 100% !important;
              max-width: none !important;
            }

            /* Responsive sidebar cards */
            .sidebar .card {
              margin-bottom: 0.5rem !important;
              overflow: hidden !important;
            }

            .sidebar .card-body {
              padding: 0.75rem !important;
              overflow: hidden !important;
              word-wrap: break-word !important;
            }

            .sidebar .card-header {
              padding: 0.5rem 0.75rem !important;
              font-size: 0.9rem !important;
            }

            /* File preview table responsive */
            .sidebar #uploadedFiles {
              font-size: 0.8rem !important;
            }

            .sidebar #uploadedFiles table {
              table-layout: fixed !important;
              width: 100% !important;
            }

            .sidebar #uploadedFiles th,
            .sidebar #uploadedFiles td {
              padding: 0.25rem !important;
              overflow: hidden !important;
              text-overflow: ellipsis !important;
              white-space: nowrap !important;
            }

            /* Application information responsive */
            .sidebar h4 {
              font-size: 1.1rem !important;
              margin-bottom: 0.75rem !important;
            }

            .sidebar p {
              font-size: 0.85rem !important;
              line-height: 1.3 !important;
              margin-bottom: 0.75rem !important;
            }

            .sidebar .mb-4 {
              margin-bottom: 1rem !important;
            }

            .sidebar .mb-2 {
              margin-bottom: 0.5rem !important;
              font-size: 0.8rem !important;
              line-height: 1.3 !important;
            }

            .sidebar .alert {
              font-size: 0.8rem !important;
              padding: 0.5rem !important;
              margin-bottom: 0.75rem !important;
            }

            /* Scale down plot content for better fit */
            .plot-container .plotly,
            .plot-container .js-plotly-plot,
            .upset-plot-container .shiny-plot-output {
              transform: scale(0.9);
              transform-origin: top left;
            }
          }

          /* Very small screens with more aggressive scaling (under 768px) */
          @media screen and (max-width: 768px) {
            .plot-container,
            .upset-plot-container {
              height: min(300px, 40vh) !important;
              min-height: 280px !important;
              padding: 0.5rem !important;
            }

            .plot-card .card-body,
            .shared-taxa-card .card-body {
              height: min(400px, 50vh) !important;
              min-height: 350px !important;
            }

            /* Enhanced shadow for very small screens */
            .plot-card.border-0.shadow-sm,
            .shared-taxa-card.border-0.shadow-sm {
              box-shadow: 0 6px 16px rgba(0,0,0,0.15) !important;
            }

            .plot-card.border-0.shadow-sm:hover,
            .shared-taxa-card.border-0.shadow-sm:hover {
              box-shadow: 0 8px 24px rgba(0,0,0,0.18) !important;
            }

            /* More aggressive sidebar scaling for tiny screens */
            .sidebar .card {
              margin-bottom: 0.375rem !important;
            }

            .sidebar .card-body {
              padding: 0.5rem !important;
            }

            .sidebar .card-header {
              padding: 0.375rem 0.5rem !important;
              font-size: 0.8rem !important;
            }

            .sidebar h4 {
              font-size: 1rem !important;
              margin-bottom: 0.5rem !important;
            }

            .sidebar p {
              font-size: 0.75rem !important;
              line-height: 1.2 !important;
              margin-bottom: 0.5rem !important;
            }

            .sidebar .mb-2 {
              margin-bottom: 0.25rem !important;
              font-size: 0.7rem !important;
              line-height: 1.2 !important;
            }

            .sidebar .alert {
              font-size: 0.7rem !important;
              padding: 0.375rem !important;
              margin-bottom: 0.5rem !important;
              line-height: 1.2 !important;
            }

            /* File preview even more compact */
            .sidebar #uploadedFiles {
              font-size: 0.7rem !important;
            }

            .sidebar #uploadedFiles th,
            .sidebar #uploadedFiles td {
              padding: 0.125rem !important;
            }

            /* More aggressive scaling for tiny screens */
            .plot-container .plotly,
            .plot-container .js-plotly-plot,
            .upset-plot-container .shiny-plot-output {
              transform: scale(0.8);
              transform-origin: top left;
            }

            /* Smaller text for better readability */
            .plot-container .plotly text,
            .upset-plot-container text {
              font-size: 10px !important;
            }
          }

          /* Metadata table responsive container */
          .metadata-table-container {
            height: calc(100vh - 200px) !important;
            min-height: 400px !important;
            overflow: hidden !important;
          }




        ")),

        # JavaScript optimizations to prevent synchronous XMLHttpRequest warnings
        tags$script(HTML("
          // Configure plotly to use async requests
          if (typeof window.Plotly !== 'undefined') {
            window.Plotly.setPlotConfig({
              plotlyServerURL: false,
              showSendToCloud: false,
              showEditInChartStudio: false
            });
          }

          // Detect RStudio viewer and show recommendation
          function detectRStudioViewer() {
            var isRStudioViewer = (
              window.parent !== window.self && 
              (window.frameElement || window.top.location.href.includes('rstudio'))
            );

            if (isRStudioViewer) {
              // Add a subtle banner recommending browser view
              setTimeout(function() {
                var banner = document.createElement('div');
                banner.innerHTML = '💡 For the best experience, click \"Open in Browser\" above';
                banner.style.cssText = `
                  position: fixed;
                  top: 0;
                  left: 0;
                  right: 0;
                  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                  color: white;
                  text-align: center;
                  padding: 8px;
                  font-size: 13px;
                  font-weight: 500;
                  z-index: 10000;
                  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
                  animation: slideDown 0.3s ease-out;
                `;

                // Add slide animation
                var style = document.createElement('style');
                style.textContent = `
                  @keyframes slideDown {
                    from { transform: translateY(-100%); opacity: 0; }
                    to { transform: translateY(0); opacity: 1; }
                  }
                `;
                document.head.appendChild(style);
                document.body.appendChild(banner);

                // Auto-hide after 5 seconds
                setTimeout(function() {
                  if (banner.parentNode) {
                    banner.style.transition = 'all 0.3s ease-out';
                    banner.style.transform = 'translateY(-100%)';
                    banner.style.opacity = '0';
                    setTimeout(function() {
                      if (banner.parentNode) {
                        banner.parentNode.removeChild(banner);
                      }
                    }, 300);
                  }
                }, 5000);
              }, 1000);
            }
          }

          detectRStudioViewer();

          // Optimize font loading and prevent async listener errors
          document.addEventListener('DOMContentLoaded', function() {
            // Wrap everything in error handling to prevent uncaught errors
            try {
            // Enhanced accessibility fixing with comprehensive form element handling

            function fixFormAccessibility() {
              var issues = [];

              try {
                // 1. Fix orphaned labels with special handling for Shiny radioButtons
                var labels = document.querySelectorAll('label[for]');
                var orphanedLabels = [];

                labels.forEach(function(label) {
                  try {
                    var forAttr = label.getAttribute('for');
                    if (forAttr) {
                      var targetElement = document.getElementById(forAttr);
                      if (!targetElement) {
                        // Special handling for Shiny radioButtons group labels
                        var radioGroup = document.querySelector('[id^=\"' + forAttr + '-\"]');
                        if (radioGroup && radioGroup.type === 'radio') {
                          // This is a radioButtons group - the label should point to the container
                          var radioContainer = document.querySelector('#' + forAttr + ', [data-shiny-input-id=\"' + forAttr + '\"]');
                          if (radioContainer) {
                            // Label is correct for radioButtons, just ensure proper ARIA
                            radioContainer.setAttribute('role', 'radiogroup');
                            if (!radioContainer.hasAttribute('aria-labelledby')) {
                              radioContainer.setAttribute('aria-labelledby', label.id || forAttr + '-label');
                            }

                            return; // Don't remove this label
                          }
                        }

                        // Try to find similar elements with more specific matching
                        var possibleTargets = document.querySelectorAll('[id^=\"' + forAttr + '\"], [id$=\"' + forAttr + '\"], [id*=\"' + forAttr + '\"]');
                        if (possibleTargets.length > 0) {
                          // Found a similar element, update the label
                          var bestMatch = possibleTargets[0];
                          label.setAttribute('for', bestMatch.id);

                        } else {
                          // Remove the for attribute if no matching element exists
                          label.removeAttribute('for');
                          orphanedLabels.push(forAttr);

                        }
                      }
                    }
                  } catch (e) {

                  }
                });

                // 2. Ensure all form elements have proper IDs and names (skip those already processed)
                var formElements = document.querySelectorAll('input:not([data-auto-id]), select:not([data-auto-id]), textarea:not([data-auto-id])');
                var missingIdElements = [];

                formElements.forEach(function(element) {
                  try {
                    if (!element.id && !element.name && !element.hasAttribute('data-skip-id')) {
                      // Generate a unique ID for elements without ID or name
                      var elementType = element.tagName.toLowerCase();
                      var elementClass = element.className || 'element';
                      var newId = 'auto-' + elementType + '-' + Math.random().toString(36).substr(2, 9);
                      element.id = newId;
                      element.setAttribute('data-auto-id', 'true');
                      missingIdElements.push(elementType);

                    }
                  } catch (e) {

                  }
                });

                // 3. Handle Shiny radioButtons specifically
                var radioGroups = document.querySelectorAll('.shiny-input-radiogroup');
                radioGroups.forEach(function(group) {
                  try {
                    var groupId = group.getAttribute('id');
                    if (groupId) {
                      group.setAttribute('role', 'radiogroup');
                      var label = document.querySelector('label[for=\"' + groupId + '\"]');
                      if (label) {
                        group.setAttribute('aria-labelledby', label.id || groupId + '-label');

                      }
                    }
                  } catch (e) {

                  }
                });

                // 4. Handle Shiny-specific form structures safely
                var shinyInputs = document.querySelectorAll('.shiny-input-container');
                shinyInputs.forEach(function(container) {
                  try {
                    var inputs = container.querySelectorAll('input, select, textarea');
                    inputs.forEach(function(input) {
                      if (input.id && !container.querySelector('label[for=\"' + input.id + '\"]')) {
                        // This is normal for Shiny - they handle labeling internally
                        // Just ensure the input has proper accessibility attributes
                        if (!input.hasAttribute('aria-label') && !input.hasAttribute('aria-labelledby')) {
                          var labelText = container.querySelector('label');
                          if (labelText && labelText.textContent) {
                            input.setAttribute('aria-label', labelText.textContent.trim());
                          }
                        }
                      }
                    });
                  } catch (e) {

                  }
                });

                // 5. Fix selectize dropdowns specifically
                var selectizeInputs = document.querySelectorAll('.selectize-input');
                selectizeInputs.forEach(function(selectize) {
                  try {
                    var parentContainer = selectize.closest('.selectize-control');
                    if (parentContainer) {
                      var originalSelect = parentContainer.querySelector('select');
                      if (originalSelect && originalSelect.id) {
                        // Ensure proper aria attributes
                        if (!selectize.hasAttribute('aria-labelledby') && !selectize.hasAttribute('aria-label')) {
                          var labelElement = document.querySelector('label[for=\"' + originalSelect.id + '\"]');
                          if (labelElement) {
                            selectize.setAttribute('aria-labelledby', labelElement.id || 'label-' + originalSelect.id);
                          } else {
                            // Use the select's own label or a default
                            var selectLabel = originalSelect.getAttribute('data-label') || 'Dropdown selection';
                            selectize.setAttribute('aria-label', selectLabel);
                          }
                        }

                      }
                    }
                  } catch (e) {

                  }
                });

                // 6. Summary report


              } catch (e) {

              }
            }

            // Run immediately and use simpler, more reliable event handling
            fixFormAccessibility();

            // Use more reliable timing-based approach instead of problematic Shiny events
            setTimeout(function() {
              fixFormAccessibility();

            }, 1000);

            setTimeout(function() {
              fixFormAccessibility();

            }, 3000);

            // Final check after everything should be loaded
            setTimeout(function() {
              fixFormAccessibility();

            }, 5000);

            // Force async loading of any remaining synchronous resources
            var links = document.querySelectorAll('link[rel=\"stylesheet\"]');
            links.forEach(function(link) {
              if (!link.hasAttribute('media')) {
                link.setAttribute('media', 'print');
                link.addEventListener('load', function() {
                  this.setAttribute('media', 'all');
                });
              }
            });

            // Simple plotly configuration without custom handlers
            if (typeof window.Plotly !== 'undefined') {
              window.Plotly.setPlotConfig({
                plotlyServerURL: false,
                showSendToCloud: false,
                showEditInChartStudio: false
              });

            }

            } catch (globalError) {

            }

            // Suppress async listener errors that come from browser extensions
            window.addEventListener('error', function(event) {
              if (event.message && event.message.includes('message channel closed')) {
                event.preventDefault();
                return false;
              }
            });

            window.addEventListener('unhandledrejection', function(event) {
              if (event.reason && event.reason.message && event.reason.message.includes('message channel closed')) {
                event.preventDefault();
                return false;
              }
            });

            // Custom message handler for resetting file inputs
            if (typeof Shiny !== 'undefined') {
              Shiny.addCustomMessageHandler('resetFileInputs', function(message) {
                try {
                  if (message.inputs && Array.isArray(message.inputs)) {
                    message.inputs.forEach(function(inputId) {
                      var fileInput = document.getElementById(inputId);
                      if (fileInput && fileInput.type === 'file') {
                        fileInput.value = '';
                        // Trigger change event to notify Shiny
                        var event = new Event('change', { bubbles: true });
                        fileInput.dispatchEvent(event);

                      }
                    });
                  }
                } catch (e) {

                }
              });
              
              // Track whether data has been loaded
              var dataLoaded = false;
              
              // Listen for custom event when data is loaded
              Shiny.addCustomMessageHandler('dataLoaded', function(message) {
                dataLoaded = message.loaded || false;
              });
              
              // Warn user before leaving/refreshing page if data is loaded
              window.addEventListener('beforeunload', function(e) {
                if (dataLoaded) {
                  // Modern browsers require returnValue to be set
                  var confirmationMessage = 'Are you sure you want to leave? All loaded data will be lost.';
                  e.preventDefault();
                  e.returnValue = confirmationMessage;
                  return confirmationMessage;
                }
              });
            }
          });

          // Prevent synchronous XMLHttpRequest warnings from plotly
          (function() {
            var originalXHR = window.XMLHttpRequest;
            window.XMLHttpRequest = function() {
              var xhr = new originalXHR();
              var originalOpen = xhr.open;
              xhr.open = function(method, url, async) {
                // Force async to true for all requests
                return originalOpen.call(this, method, url, async !== false);
              };
              return xhr;
            };
          })();
        "))
        
      )
    ),

    nav_panel(
      title = tagList(
        tags$i(class = "fas fa-upload me-2"),
        "Data Upload & Preview"
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 440,
          open = TRUE,
          class = "data-upload-sidebar",
          card(
            class = "border-0 shadow-lg",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-cloud-upload-alt me-2 text-info"),
                tags$strong("Upload Files")
              )
            ),
            card_body(
              div(class = "scale-on-small-container",
                div(class = "scale-on-small-content",
                  div(
                    class = "mb-3",
                    fileInput("mainFiles", 
                             "Kraken reports or phyloseq object (.txt or .rds)",
                             multiple = TRUE, accept = c(".rds", ".txt"))
                  ),
                  div(
                    class = "mb-3",
                    fileInput("metadataFile", 
                             "Metadata file for kraken/bracken reports",
                             accept = c(".txt", ".tsv"))
                  ),
                  div(
                    class = "mb-3",
                    fileInput("optionalFiles", 
                             "Optional: Bracken reports (must match Kraken samples)",
                             multiple = TRUE, accept = c(".txt"))
                  ),
                  div(
                    id = "validationStatus",
                    class = "mb-3",
                    style = "min-height: 30px;",
                    uiOutput("fileValidationStatus")
                  ),
                  div(
                    class = "d-grid gap-2",
                    actionButton("loadDemoBtn", 
                               "Use DEMO data",
                               class = "btn-demo btn-lg",
                               icon = icon("rocket"),
                               title = "Load example dataset to explore the app"),
                    actionButton("processBtn", 
                               "Process reports",
                               class = "btn-primary btn-lg",
                               icon = icon("cogs")),
                    actionButton("clearDataBtn", 
                               "Clear Plots",
                               class = "btn-warning btn-sm",
                               icon = icon("trash-alt"),
                               title = "Clear all plots and reset the application")
                  )
                )
              )
            )
          )
        ),

        
        div(
          style = "display: flex; flex-direction: column; gap: 1rem; height: 100%;",

          card(
            class = "border-0 shadow-lg",
            style = "flex: 0.4; min-height: 300px;",
          card_header(
            class = "bg-gradient text-dark",
            style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
            tagList(
              tags$i(class = "fas fa-list-alt me-2 text-success"),
              tags$strong("Uploaded Files Preview")
            )
          ),
          card_body(
            style = "padding: 0; height: 100%; display: flex; flex-direction: column;",
            div(
              class = "scale-on-small-container",
              style = "flex: 1; height: 100%;",
              div(
                class = "scale-on-small-content",
                style = "height: 100%;",
                div(
                  style = "height: 100%; padding: 1rem;",
                  DT::dataTableOutput("uploadedFiles", height = "100%")
                )
              )
            )
          )
        ),

          card(
            class = "border-0 shadow-lg",
            style = "flex: 0.6; min-height: 300px;",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-info-circle me-2 text-warning"),
                tags$strong("Application Information")
              )
            ),
            card_body(
              div(class = "scale-on-small-container",
                div(class = "scale-on-small-content",
                  h4(
                    class = "text-primary mb-2",
                    tagList(
                      tags$i(class = "fas fa-microscope me-2"),
                      "Microbiome Analysis Dashboard"
                    )
                  ),
                  p(class = "text-muted mb-2", "Tools for analyzing microbiome data from PUDU pipeline:"),
                  div(
                    class = "mb-3",
                    div(class = "mb-1", tags$i(class = "fas fa-chart-line text-primary me-1"), tags$strong("Alpha diversity:"), " Within-sample diversity"),
                    div(class = "mb-1", tags$i(class = "fas fa-chart-line text-primary me-1"), tags$strong("Beta diversity:"), " Between-sample comparison"),
                    div(class = "mb-1", tags$i(class = "fas fa-chart-line text-primary me-1"), tags$strong("Shared taxa:"), " UpSet plots and tables"),
                    div(class = "mb-1", tags$i(class = "fas fa-chart-line text-primary me-1"), tags$strong("Taxonomic composition:"), " Relative abundance plots")
                  ),
                  div(
                    class = "alert alert-info border-0 shadow-sm",
                    style = "border-radius: 8px; font-size: 0.75rem; padding: 0.5rem;",
                    HTML(paste0(
                      "<i class='fas fa-info-circle me-1'></i>",
                      "<strong style='font-size: 1.1rem;'>Upload:</strong> '.rds' (phyloseq) or '.txt' (Kraken/Bracken) + metadata.<br>",
                      "Metadata needs 'sample_name' column matching file base names."
                    ))
                  )
                )
              )
            )
          )
        )
      )
    ),

    nav_panel(
      title = tagList(
        tags$i(class = "fas fa-table me-2"),
        "Metadata Viewer"
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 320,
          open = TRUE,

          # Metadata Summary Card
          card(
            class = "border-0 shadow-lg mb-4",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-info me-2 text-info"),
                tags$strong("Metadata Summary")
              )
            ),
            card_body(
              div(
                id = "metadataSummary",
                style = "min-height: 120px;",
                conditionalPanel(
                  condition = "output.metadataAvailable == false",
                  div(
                    class = "text-center text-muted py-4",
                    tags$i(class = "fas fa-database fa-2x mb-2 d-block text-secondary"),
                    p("No metadata available"),
                    p(class = "small", "Upload files to view metadata information")
                  )
                ),
                conditionalPanel(
                  condition = "output.metadataAvailable == true",
                  div(
                    tags$h6(class = "text-primary mb-2", "Dataset Information:"),
                    tags$ul(
                      class = "list-unstyled mb-0 small",
                      tags$li(
                        class = "mb-1",
                        tags$strong("Samples: "), 
                        textOutput("sampleCount", inline = TRUE)
                      ),
                      tags$li(
                        class = "mb-1",
                        tags$strong("Variables: "), 
                        textOutput("variableCount", inline = TRUE)
                      ),
                      tags$li(
                        class = "mb-1",
                        tags$strong("Data Type: "), 
                        textOutput("dataType", inline = TRUE)
                      )
                    )
                  )
                )
              )
            )
          ),

          # Display Options Card
          conditionalPanel(
            condition = "output.metadataAvailable == true",
            card(
              class = "border-0 shadow-lg mb-4",
              card_header(
                class = "bg-gradient text-dark",
                style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
                tagList(
                  tags$i(class = "fas fa-sliders-h me-2 text-success"),
                  tags$strong("Display Options")
                )
              ),
              card_body(
                div(
                  class = "mb-3",
                  checkboxInput("showAllColumns", "Show all columns", value = TRUE)
                ),
                conditionalPanel(
                  condition = "input.showAllColumns == false",
                  div(
                    class = "mb-3",
                    selectInput("selectedColumns", "Select columns to display:", choices = NULL, multiple = TRUE)
                  )
                ),
                div(
                  class = "mb-3",
                  numericInput("rowsToShow", "Rows per page:", 25, min = 5, max = 200, step = 5)
                )
              )
            )
          ),

          # Export Options Card
          conditionalPanel(
            condition = "output.metadataAvailable == true",
            card(
              class = "border-0 shadow-lg",
              card_header(
                class = "bg-gradient text-dark",
                style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
                tagList(
                  tags$i(class = "fas fa-download me-2 text-primary"),
                  tags$strong("Export Metadata")
                )
              ),
              card_body(
                div(
                  class = "d-grid gap-2",
                  downloadButton("downloadMetadataCSV", "Download as CSV", class = "btn-darkblue btn-sm", icon = icon("file-csv")),
                  downloadButton("downloadMetadataExcel", "Download as Excel", class = "btn-darkblue btn-sm", icon = icon("file-excel"))
                )
              )
            )
          )
        ),

        # Main Metadata Table Area
        card(
          class = "border-0 shadow-sm",
          card_header(
            tagList(
              tags$i(class = "fas fa-table me-2 text-primary"),
              "Metadata Table"
            )
          ),
          card_body(
            conditionalPanel(
              condition = "output.metadataAvailable == false",
              div(
                class = "text-center py-5",
                tags$i(class = "fas fa-table fa-3x mb-3 text-muted"),
                h4(class = "text-muted mb-2", "No Metadata to Display"),
                p(class = "text-muted", "Please upload your data files to view the associated metadata."),
                p(class = "small text-muted", "Supported formats: RDS files (phyloseq objects) or TXT files with separate metadata")
              )
            ),
            conditionalPanel(
              condition = "output.metadataAvailable == true",
              div(
                class = "metadata-table-container",
                DTOutput("metadataTable", width = "100%", height = "100%")
              )
            )
          )
        )
      )
    ),

    nav_panel(
      title = tagList(
        tags$i(class = "fas fa-chart-line me-2"),
        "Alpha Diversity"
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 350,
          open = TRUE,

          # Plot Type Selection
          card(
            class = "border-0 shadow-sm mb-3",
            card_header(
              tagList(
                tags$i(class = "fas fa-chart-bar me-2 text-info"),
                "Plot Configuration"
              )
            ),
            card_body(
              radioButtons("alphaPlotType", 
                          "Select Plot Type:",
                          choices = c("Scatter Plot" = "scatter", 
                                     "Violin Plot" = "violin", 
                                     "Box Plot" = "box"),
                          selected = "scatter")
            )
          ),

          # Conditional Parameters
          conditionalPanel(
            condition = "input.alphaPlotType == 'scatter'",
            card(
              class = "border-0 shadow-sm mb-3",
              card_header("Scatter Plot Options"),
              card_body(
                selectInput("alphaGroup", "X axis (Scatter):", choices = NULL),
                checkboxInput("use_color_sc","Set dot color", FALSE),
                sliderInput("dotSize_alpha", "Dot Size:", min = 1, max = 10, value = 3),
                conditionalPanel(
                  condition = "input.use_color_sc == true",
                  selectInput("colorAlpha", "Color by:", choices = NULL)
                )
              )
            )
          ),
          conditionalPanel(
            condition = "input.alphaPlotType == 'violin'",
            card(
              class = "border-0 shadow-sm mb-3",
              card_header("Violin Plot Options"),
              card_body(
                selectInput("alpha_viocolor", "X axis (Violin):", choices = NULL),
                checkboxInput("use_color_vi","Set violin color")
              )
            )
          ),
          conditionalPanel(
            condition = "input.alphaPlotType == 'box'",
            card(
              class = "border-0 shadow-sm mb-3",
              card_header("Box Plot Options"),
              card_body(
                selectInput("alpha_boxgroup", "Group by (Box):", choices = NULL),
                checkboxInput("use_color_box", "Set box color")
              )
            )
          ),

          # Diversity Metrics
          card(
            class = "border-0 shadow-sm",
            card_header(
              tagList(
                tags$i(class = "fas fa-calculator me-2 text-success"),
                "Diversity Metrics"
              )
            ),
            card_body(
              uiOutput("metric_selectors")
            )
          )
        ),

        # Main Plot Area
        div(
          style = "position: relative;",
          # Floating download button for this tab
          absolutePanel(
            top = 10, right = 10,
            style = "z-index: 999;",
            downloadButton(
              "downloadAlphaPlot", 
              label = "Download",
              class = "btn floating-download btn-sm",
              style = "border: none; color: white; font-weight: 600;"
            )
          ),
          card(
            class = "border-0 shadow-sm plot-card",
            card_header(
              tagList(
                tags$i(class = "fas fa-chart-line me-2 text-primary"),
                "Alpha Diversity Analysis"
              )
            ),
            card_body(
              div(
                class = "plot-container",
                plotlyOutput("alphaPlotOutput", height = "100%", width = "100%")
              )
            )
          )
        )
      )
    ),

    nav_panel(
      title = tagList(
        tags$i(class = "fas fa-chart-line me-2"),
        "Beta Diversity"
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 350,
          open = TRUE,

          card(
            class = "border-0 shadow-sm mb-3",
            card_header(
              tagList(
                tags$i(class = "fas fa-sitemap me-2 text-info"),
                "Method & Appearance"
              )
            ),
            card_body(
              selectInput("betaOrdination", "Ordination Method:", choices = NULL),
              selectInput("shapeBy_bd", "Shape by:", choices = NULL),
              sliderInput("dotSize_bd", "Dot Size:", min = 1, max = 10, value = 3)
            )
          ),

          card(
            class = "border-0 shadow-sm mb-3",
            card_header("Labeling & Colors"),
            card_body(
              checkboxInput("use_labels_beta", "Print labels when saving", value = FALSE),
              conditionalPanel(
                condition = "output.showfilterBeta == true && input.use_labels_beta",
                selectInput("labelGroup", "Label by:", choices = NULL)
              ),
              checkboxInput("use_color_beta", "Color by Group", value = FALSE),
              conditionalPanel(
                condition = "input.use_color_beta == true",
                selectInput("betaGroup", "Color by:", choices = NULL)
              )
            )
          ),

          conditionalPanel(
            condition = "output.showTaxFilterControls == true",
            card(
              class = "border-0 shadow-sm",
              card_header(
                tagList(
                  tags$i(class = "fas fa-filter me-2 text-warning"),
                  "Taxonomic Filtering"
                )
              ),
              card_body(
                selectInput("tax_rank_filter", "Taxonomic Level:", choices = NULL)
              )
            )
          )
        ),

        div(
          style = "position: relative;",
          # Floating download button for this tab
          absolutePanel(
            top = 10, right = 10,
            style = "z-index: 999;",
            downloadButton(
              "downloadBetaPlot", 
              label = "Download",
              class = "btn floating-download btn-sm",
              style = "border: none; color: white; font-weight: 600;"
            )
          ),
          card(
            class = "border-0 shadow-sm plot-card",
            card_header(
              tagList(
                tags$i(class = "fas fa-chart-line me-2 text-primary"),
                "Beta Diversity Analysis"
              )
            ),
            card_body(
              div(
                class = "plot-container",
                plotlyOutput("betaPlot", height = "100%", width = "100%")
              )
            )
          )
        )
      )
    ),

    nav_panel(
      title = tagList(
        tags$i(class = "fas fa-chart-line me-2"),
        "Shared Taxa"
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 350,
          open = TRUE,

          conditionalPanel(
            condition = "output.showDomainFilterControls == true",
            card(
              class = "border-0 shadow-lg mb-4 bg-light",
              style = "min-height: 180px;",
              card_header(
                class = "bg-gradient text-dark",
                style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important; padding: 1.25rem 1.5rem; font-size: 1.05rem;",
                tagList(
                  tags$i(class = "fas fa-search me-2 text-info", style = "font-size: 1.1rem;"),
                  tags$strong("Domain Filter")
                )
              ),
              card_body(
                style = "padding: 2rem 1.5rem;",
                selectInput("domainFilterShared", 
                           "Filter by Domain:",
                           choices = NULL,
                           width = "100%")
              )
            )
          ),

          card(
            class = "border-0 shadow-lg mb-4 bg-light",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-layer-group me-2 text-success"),
                tags$strong("Taxonomic Level Selection")
              )
            ),
            card_body(
              selectInput("upset_rank", 
                         "Select Taxonomic Rank:",
                         choices = c("Phylum", "Class", "Order", "Family", "Genus", "Species"),
                         width = "100%")
            )
          ),

          card(
            class = "border-0 shadow-lg mb-3",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-check-square me-2 text-warning"),
                tags$strong("Sample Selection")
              )
            ),
            card_body(
              checkboxGroupInput("selectedSamples", "Select Samples:", choices = NULL)
            )
          ),

          card(
            class = "border-0 shadow-lg",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-download me-2 text-primary"),
                tags$strong("Download Options")
              )
            ),
            card_body(
              div(
                class = "d-grid gap-2",
                downloadButton("downloadUpsetPlot", 
                             "Download Plot",
                             class = "btn-darkblue",
                             icon = icon("chart-bar")),
                downloadButton("downloadSharedTaxa", 
                             "Download Shared Taxa",
                             class = "btn-darkblue",
                             icon = icon("table")),
                downloadButton("downloadBinaryMatrix", 
                             "Download Binary Matrix",
                             class = "btn-darkblue",
                             icon = icon("th"))
              )
            )
          )
        ),

        card(
          class = "border-0 shadow-sm shared-taxa-card",
          card_header(
            tagList(
              tags$i(class = "fas fa-chart-line me-2 text-primary"),
              "Shared Taxa Analysis"
            )
          ),
          card_body(
            class = "p-0",
            tabsetPanel(
              id = "upsetTabs",
              type = "pills",
              tabPanel(
                "UpSet Plot",
                icon = icon("chart-bar"),
                div(
                  class = "upset-plot-container",
                  style = "padding: 1rem;",
                  plotOutput("upsetPlot", height = "100%", width = "100%")
                )
              ),
              tabPanel(
                "Shared Taxa Table",
                icon = icon("table"),
                div(
                  class = "p-3",
                  style = "height: calc(100vh - 250px); overflow: auto;",
                  DTOutput("sharedTaxaList")
                )
              )
            )
          )
        )
      )
    ),

    nav_panel(
      title = tagList(
        tags$i(class = "fas fa-chart-line me-2"),
        "Taxonomic Distribution"
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 350,
          open = TRUE,

          conditionalPanel(
            condition = "output.showDomainFilterControls == true",
            card(
              class = "border-0 shadow-lg mb-4 bg-light",
              style = "min-height: 180px;",
              card_header(
                class = "bg-gradient text-dark",
                style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important; padding: 1.25rem 1.5rem; font-size: 1.05rem;",
                tagList(
                  tags$i(class = "fas fa-filter me-2 text-info", style = "font-size: 1.1rem;"),
                  tags$strong("Domain Filter")
                )
              ),
              card_body(
                style = "padding: 2rem 1.5rem;",
                selectInput("domainFilter", 
                           "Filter by Domain:",
                           choices = NULL,
                           width = "100%")
              )
            )
          ),

          card(
            class = "border-0 shadow-lg mb-4 bg-light",
            card_header(
              class = "bg-gradient text-dark",
              style = "background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%) !important;",
              tagList(
                tags$i(class = "fas fa-sitemap me-2 text-success"),
                tags$strong("Taxonomic Settings")
              )
            ),
            card_body(
              selectInput("taxLevel", 
                         "Taxonomic Level:",
                         choices = NULL,
                         width = "100%"),
              selectInput("taxaGroup", 
                         "X Axis:",
                         choices = NULL,
                         width = "100%")
            )
          ),

          card(
            class = "border-0 shadow-sm",
            card_header(
              tagList(
                tags$i(class = "fas fa-eye me-2 text-warning"),
                "Display Options"
              )
            ),
            card_body(
              checkboxInput("filterTop", "Filter Top N Taxa", value = FALSE),
              conditionalPanel(
                condition = "input.filterTop == true",
                numericInput("numAb", "Show Top N Taxa:", 20, min = 1, max = 50)
              ),
              checkboxInput("showLegend", "Show Legend", value = TRUE)
            )
          )
        ),

        div(
          style = "position: relative;",
          absolutePanel(
            top = 10, right = 10,
            style = "z-index: 999;",
            div(
              style = "display: flex; gap: 5px;",
              downloadButton(
                "downloadTaxonomicData", 
                label = "Data",
                class = "btn floating-download btn-sm",
                style = "border: none; color: white; font-weight: 600;",
                title = "Download taxonomy table data as CSV"
              ),
              downloadButton(
                "downloadTaxonomicPlot", 
                label = "Plot",
                class = "btn floating-download btn-sm",
                style = "border: none; color: white; font-weight: 600;",
                title = "Download plot as PNG"
              )
            )
          ),
          card(
            class = "border-0 shadow-sm plot-card",
            card_header(
              tagList(
                tags$i(class = "fas fa-chart-line me-2 text-primary"),
                "Taxonomic Composition"
              )
            ),
            card_body(
              div(
                class = "plot-container",
                plotlyOutput("taxPlot", height = "100%", width = "100%")
              )
            )
          )
        )
      )
    ),

    footer = tagList(
      # Loading Overlay
      conditionalPanel(
        condition = "$('html').hasClass('shiny-busy')",
        div(
          class = "loading-overlay",
          style = "
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            z-index: 9999;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
          ",
          div(
            style = "text-align: center;",
            div(
              class = "spinner-border text-primary",
              role = "status",
              style = "width: 4rem; height: 4rem; margin-bottom: 1rem;",
              tags$span(class = "visually-hidden", "Loading...")
            ),
            h3(
              class = "text-primary fw-bold",
              tagList(
                tags$i(class = "fas fa-cogs me-2"),
                "Processing your data..."
              )
            ),
            p(class = "text-muted", "Please wait while we analyze your microbiome data.")
          )
        )
      ),

      div(
        class = "github-footer",
        div(
          style = "display: flex; align-items: center; justify-content: center;",
          tags$i(class = "fab fa-github", style = "margin-right: 8px; font-size: 18px;"),
          tags$a(
            href = "https://github.com/",
            target = "_blank",
            "For additional information about PUDU pipeline or PUDU app, please visit our GitHub",
            style = "text-decoration: none; color: inherit; font-weight: 500;"
          )
        )
      )
    )
  )
}