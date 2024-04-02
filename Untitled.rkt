#lang racket/gui
;To whoever reviews this EA, I'm sorry.
;This is going to be the worst Racket code you have ever seen.

(require rsound)
(require try-catch)
(require dyoo-while-loop)

(define stream "")
(define rsobj "")
(define sample-rate 0)

(define currentPlay #f)

(define frame (new frame% [label "WAV Player"]))

(define location (new text-field% [parent frame]
                                  [label "File Location"]))

(define (playMedia [start-pos 0])
  (try [(define txtLoc (send location get-value))
        (define frames (rs-read-frames txtLoc))
        (send pause enable #t)
        (send stop-button enable #t)
        (set! currentPlay #f)
        (set! rsobj (rs-read/clip txtLoc start-pos frames))
        (set! sample-rate (rs-read-sample-rate txtLoc))
        (define frames-ahead 0)
        (set! stream (make-pstream))
        (pstream-play stream rsobj)
        (try [(send frame delete-child prog)]
             [catch])
        (set! prog (new slider% [label ""]
                                [min-value 0]
                                [max-value (exact-round(/ frames (rs-read-sample-rate txtLoc)))]
                                [parent frame]
                                [callback (lambda (slider event)
                                            (stop)
                                            (set! frames-ahead (* (send prog get-value) sample-rate))
                                            (pstream-clear! stream)
                                            (set! stream (make-pstream))
                                            (set! rsobj (rs-read/clip txtLoc (* (send prog get-value) sample-rate) frames))
                                            (pstream-play stream rsobj))]))
        (while (and (< (pstream-current-frame stream) frames) (not currentPlay))
               (send prog set-value (exact-round (/ (+ (+ (pstream-current-frame stream) frames-ahead) current-frame) sample-rate)))
               (sleep/yield 0.5))]))

(define current-frame 0)

(define (pause-media)
  (define t (send prog get-value))
  (set! current-frame (+ current-frame (pstream-current-frame stream)))
  (set! currentPlay #t)
  (stop)
  (pstream-clear! stream)
  (send prog set-value t)
  (send prog enable #f)
  (sleep/yield 0.2)
  (send prog set-value t)
  (send pause enable #f))

(define (stop-media)
  (set! current-frame 0)
  (set! currentPlay #t)
  (stop)
  (send prog enable #f)
  (send prog set-value 0)
  (send pause enable #f)
  (send stop-button enable #f))

(define (record time)
 (define frames (* time (default-sample-rate)))
  (record-sound frames))
  

(define panel (new horizontal-panel% [parent frame]))

(define play (new button% [parent panel]
             [label "Play"]
             [callback (lambda (button event)
                         (playMedia current-frame))]))

(define pause (new button% [parent panel]
             [label "Pause"]
             [enabled #f]
             [callback (lambda (button event)
                         (pause-media))]))

(define stop-button (new button% [parent panel]
             [label "Stop"]
             [enabled #f]
             [callback (lambda (button event)
                         (stop-media))]))
(define record-button (new button% [parent panel]
                                   [label "Record"]
                                   [callback (lambda (button event)
                                               (define t (new dialog% [label "WAV Player"]))
                                               (define tx (new text-field% [parent t]
                                                                           [label "Time in seconds"]))
                                               (new button% [parent t]
                                                            [label "Ok"]
                                                            [callback (lambda (button event2)
                                                                        (rs-write (record (string->number (send tx get-value))) (send location get-value))
                                                                        (send t show #f))])
                                               (send t show #t))]))
                                   
             
(define prog (new slider% [label ""]
                          [min-value 0]
                          [max-value 0]
                          [parent frame]
                          [enabled #f]))
                         
(send frame show #t)
                                      