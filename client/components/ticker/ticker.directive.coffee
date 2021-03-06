'use strict'

angular.module 'fundraiserApp'
.directive 'ticker', ($interval,$filter,$compile)->
  restrict: 'EA',
  scope:
    value:'@value'
  link: (scope, element, attrs) ->    
    
    element.addClass 'tick tick-scroll dollar-container'

    if element.next().length
      element.next().insertBefore(element)

    contentTr = angular.element('<div class="dollar-append">$</div>')
    contentTr.insertAfter(element)
    $compile(contentTr)(scope)

    easeOutCubic=(currentIteration, startValue, changeInValue, totalIterations) ->
      changeInValue * (Math.pow(currentIteration / totalIterations - 1, 3) + 1) + startValue;

    easeInCubic=(currentIteration, startValue, changeInValue, totalIterations)->
      changeInValue * Math.pow(currentIteration / totalIterations, 3) + startValue;

    zeroPad=(num, places)->
      zero = places - num.toString().length + 1
      Array(+(zero > 0 && zero)).join("0") + num

    iteration=0
    stopAt=10
    startNumber=0
    string=($filter('number')(scope.value,0))
    string=string.replace(/[0-9]/g, '0')
    string='1'+string.slice(1)
    element.text string
    ticker=element.ticker
      delay:500
      separators:true
      incremental:(current)->
        if iteration<stopAt
          iteration++
          this.options.delay=easeOutCubic iteration, 20, 500, stopAt
          value=parseInt easeInCubic iteration, 0, scope.value, stopAt
        else
          this.options.delay=2000
          value=scope.value
        zeroPad(value,scope.value.toString().length)

    false