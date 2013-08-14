app = angular.module('app', [])

app.factory 'Data', () ->
  finished = ['finished one', 'finished two']
  todos = [{content: '#todo task', done: true}]
  return {
    finished: finished,
    todos: todos,
    current_selected: ''
  }

app.factory 'Alarm', () ->
  return document.getElementById('finish_alarm')

app.filter 'pomotime', () ->
  (text) ->
    sec = (100 + text % 60).toString().substr(1)
    min = (~~(text / 60) + 100).toString().substr(1)

    "#{min}:#{sec}"

app.controller 'ClockCtrl', ($scope, $timeout, Data, Alarm) ->
  $scope.data = Data
  prom = null
  $scope.status = 'start'
  $scope.duration = 0

  $scope.tick_start = () ->
    $scope.status = 'process'
    $scope.start_time = new Date()
    $scope.duration = 5
    (tick = () ->
      if $scope.duration <= 0
        $timeout.cancel(prom)
        $scope.tick_end()
        return

      console.log 'tick'
      $scope.duration -= 1
      prom = $timeout(tick, 1000)
    )()

  $scope.tick_end = () ->
    $scope.status = 'end'
    Alarm.play()

  $scope.save_finished_task = () ->
    $scope.data.finished.unshift $scope.data.current_selected
    $scope.data.current_selected = ''
    $scope.status = 'start'

app.controller 'FinishedCtrl', ($scope, Data) ->
  $scope.data = Data

app.controller 'TodoCtrl', ($scope, Data) ->
  $scope.data = Data
  $scope.add_todo = () ->
    $scope.data.todos.unshift({content: $scope.newtodocontent, done: false})
    $scope.newtodocontent = ''

  $scope.set_current_selected = (item) ->
    $scope.data.current_selected = item.content
