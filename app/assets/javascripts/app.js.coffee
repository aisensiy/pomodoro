app = angular.module('app', [])

app.filter 'pomotime', () ->
  (text) ->
    sec = (100 + text % 60).toString().substr(1)
    min = (~~(text / 60) + 100).toString().substr(1)

    "#{min}:#{sec}"

app.controller 'ClockCtrl', ($scope, $timeout) ->
  prom = null
  $scope.status = 'start'
  $scope.duration = 0

  $scope.tick_start = () ->
    $scope.status = 'process'
    $scope.start_time = new Date()
    $scope.duration = 10
    (tick = () ->
      if $scope.duration <= 0
        $timeout.cancel(prom)
        $scope.tick_end()
      $scope.duration -= 1
      prom = $timeout(tick, 1000)
    )()

  $scope.tick_end = () ->
    $scope.status = 'end'

