;; Usage Analytics Contract
;; Monitors tool popularity and community needs

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_INVALID_PERIOD (err u401))
(define-constant ERR_DATA_NOT_FOUND (err u402))

;; Data Variables
(define-data-var total-usage-events uint u0)
(define-data-var analytics-enabled bool true)

;; Data Maps
(define-map tool-usage-stats
  { tool-id: uint }
  {
    total-borrows: uint,
    total-usage-days: uint,
    average-loan-duration: uint,
    popularity-score: uint,
    last-borrowed: (optional uint),
    seasonal-demand: (string-ascii 20)
  }
)

(define-map monthly-usage-data
  { year: uint, month: uint }
  {
    total-borrows: uint,
    unique-borrowers: uint,
    most-popular-tool: (optional uint),
    total-usage-hours: uint
  }
)

(define-map user-usage-patterns
  { user: principal }
  {
    total-borrows: uint,
    favorite-category: (string-ascii 30),
    average-loan-duration: uint,
    seasonal-activity: (string-ascii 20),
    reliability-score: uint
  }
)

(define-map category-analytics
  { category: (string-ascii 30) }
  {
    total-borrows: uint,
    unique-users: uint,
    average-duration: uint,
    peak-season: (string-ascii 20),
    growth-trend: (string-ascii 10)
  }
)

(define-map demand-forecasting
  { tool-id: uint, period: (string-ascii 20) }
  {
    predicted-demand: uint,
    confidence-level: uint,
    historical-average: uint,
    trend-direction: (string-ascii 10)
  }
)

;; Public Functions

;; Record tool usage event
(define-public (record-usage-event (tool-id uint) (user principal) (duration-days uint) (category (string-ascii 30)))
  (begin
    (asserts! (var-get analytics-enabled) (err u403))

    ;; Update tool usage statistics
    (update-tool-usage-stats tool-id duration-days)

    ;; Update user usage patterns
    (update-user-usage-patterns user duration-days category)

    ;; Update category analytics
    (update-category-analytics category duration-days user)

    ;; Update monthly data
    (update-monthly-usage-data)

    ;; Increment total events
    (var-set total-usage-events (+ (var-get total-usage-events) u1))

    (ok true)
  )
)

;; Generate popularity report
(define-public (generate-popularity-report (period (string-ascii 20)))
  (begin
    (asserts! (is-valid-period period) ERR_INVALID_PERIOD)

    ;; This would generate a comprehensive report
    ;; For now, return success
    (ok "Report generated successfully")
  )
)

;; Update demand forecast
(define-public (update-demand-forecast (tool-id uint) (period (string-ascii 20)) (predicted-demand uint))
  (let ((confidence (calculate-confidence-level tool-id)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)

    (map-set demand-forecasting
      { tool-id: tool-id, period: period }
      {
        predicted-demand: predicted-demand,
        confidence-level: confidence,
        historical-average: (get-historical-average tool-id),
        trend-direction: (calculate-trend-direction tool-id)
      }
    )

    (ok true)
  )
)

;; Toggle analytics collection
(define-public (toggle-analytics (enabled bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (var-set analytics-enabled enabled)
    (ok enabled)
  )
)

;; Read-only Functions

;; Get tool usage statistics
(define-read-only (get-tool-usage-stats (tool-id uint))
  (map-get? tool-usage-stats { tool-id: tool-id })
)

;; Get monthly usage data
(define-read-only (get-monthly-usage-data (year uint) (month uint))
  (map-get? monthly-usage-data { year: year, month: month })
)

;; Get user usage patterns
(define-read-only (get-user-usage-patterns (user principal))
  (map-get? user-usage-patterns { user: user })
)

;; Get category analytics
(define-read-only (get-category-analytics (category (string-ascii 30)))
  (map-get? category-analytics { category: category })
)

;; Get demand forecast
(define-read-only (get-demand-forecast (tool-id uint) (period (string-ascii 20)))
  (map-get? demand-forecasting { tool-id: tool-id, period: period })
)

;; Get total usage events
(define-read-only (get-total-usage-events)
  (var-get total-usage-events)
)

;; Get most popular tools
(define-read-only (get-most-popular-tools)
  ;; This would return a list of top tools by popularity
  ;; For now, return a placeholder
  (list u1 u2 u3)
)

;; Get usage trends
(define-read-only (get-usage-trends (period (string-ascii 20)))
  ;; This would analyze trends over the specified period
  ;; Return trend data structure
  { trend: "increasing", percentage: u15 }
)

;; Private Functions

;; Update tool usage statistics
(define-private (update-tool-usage-stats (tool-id uint) (duration-days uint))
  (let ((stats (default-to
    { total-borrows: u0, total-usage-days: u0, average-loan-duration: u0, popularity-score: u0, last-borrowed: none, seasonal-demand: "medium" }
    (map-get? tool-usage-stats { tool-id: tool-id })
  )))
    (let ((new-total-borrows (+ (get total-borrows stats) u1))
          (new-total-days (+ (get total-usage-days stats) duration-days)))
      (map-set tool-usage-stats
        { tool-id: tool-id }
        (merge stats {
          total-borrows: new-total-borrows,
          total-usage-days: new-total-days,
          average-loan-duration: (/ new-total-days new-total-borrows),
          popularity-score: (calculate-popularity-score new-total-borrows new-total-days),
          last-borrowed: (some block-height)
        })
      )
    )
  )
)

;; Update user usage patterns
(define-private (update-user-usage-patterns (user principal) (duration-days uint) (category (string-ascii 30)))
  (let ((patterns (default-to
    { total-borrows: u0, favorite-category: category, average-loan-duration: u0, seasonal-activity: "medium", reliability-score: u100 }
    (map-get? user-usage-patterns { user: user })
  )))
    (let ((new-total-borrows (+ (get total-borrows patterns) u1))
          (new-total-days (+ (* (get average-loan-duration patterns) (get total-borrows patterns)) duration-days)))
      (map-set user-usage-patterns
        { user: user }
        (merge patterns {
          total-borrows: new-total-borrows,
          average-loan-duration: (/ new-total-days new-total-borrows),
          favorite-category: category ;; Simplified - would need more logic to determine actual favorite
        })
      )
    )
  )
)

;; Update category analytics
(define-private (update-category-analytics (category (string-ascii 30)) (duration-days uint) (user principal))
  (let ((analytics (default-to
    { total-borrows: u0, unique-users: u0, average-duration: u0, peak-season: "spring", growth-trend: "stable" }
    (map-get? category-analytics { category: category })
  )))
    (let ((new-total-borrows (+ (get total-borrows analytics) u1))
          (new-total-duration (+ (* (get average-duration analytics) (get total-borrows analytics)) duration-days)))
      (map-set category-analytics
        { category: category }
        (merge analytics {
          total-borrows: new-total-borrows,
          average-duration: (/ new-total-duration new-total-borrows),
          unique-users: (+ (get unique-users analytics) u1) ;; Simplified - would need set logic
        })
      )
    )
  )
)

;; Update monthly usage data
(define-private (update-monthly-usage-data)
  (let ((current-year u2024) ;; Simplified - would calculate from block height
        (current-month u1))
    (let ((monthly-data (default-to
      { total-borrows: u0, unique-borrowers: u0, most-popular-tool: none, total-usage-hours: u0 }
      (map-get? monthly-usage-data { year: current-year, month: current-month })
    )))
      (map-set monthly-usage-data
        { year: current-year, month: current-month }
        (merge monthly-data {
          total-borrows: (+ (get total-borrows monthly-data) u1),
          unique-borrowers: (+ (get unique-borrowers monthly-data) u1) ;; Simplified
        })
      )
    )
  )
)

;; Calculate popularity score
(define-private (calculate-popularity-score (total-borrows uint) (total-days uint))
  ;; Simple popularity calculation: borrows * average duration
  (if (> total-borrows u0)
    (* total-borrows (/ total-days total-borrows))
    u0
  )
)

;; Calculate confidence level for forecasting
(define-private (calculate-confidence-level (tool-id uint))
  ;; Simplified confidence calculation based on historical data
  (match (map-get? tool-usage-stats { tool-id: tool-id })
    stats (if (> (get total-borrows stats) u10) u85 u60)
    u50
  )
)

;; Get historical average for tool
(define-private (get-historical-average (tool-id uint))
  (match (map-get? tool-usage-stats { tool-id: tool-id })
    stats (get average-loan-duration stats)
    u0
  )
)

;; Calculate trend direction
(define-private (calculate-trend-direction (tool-id uint))
  ;; Simplified trend calculation
  "stable"
)

;; Validate time period
(define-private (is-valid-period (period (string-ascii 20)))
  (or
    (is-eq period "weekly")
    (or
      (is-eq period "monthly")
      (or
        (is-eq period "quarterly")
        (is-eq period "yearly")
      )
    )
  )
)
