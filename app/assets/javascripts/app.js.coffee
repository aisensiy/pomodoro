app = angular.module('app', ['ngResource'])

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

app.factory 'Todo', ($resource) ->
  $resource '/todos/:id', {id: '@id'},
    update: {method: 'PUT', params: {}}

app.factory 'Finished', ($resource) ->
  $resource('/finisheds/:id', {id: '@id'})

app.filter 'pomotime', () ->
  (text) ->
    sec = (100 + text % 60).toString().substr(1)
    min = (~~(text / 60) + 100).toString().substr(1)

    "#{min}:#{sec}"

app.controller 'ClockCtrl', ($scope, $timeout, Data, Alarm, Finished) ->
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
    finished = new Finished
      content: $scope.data.current_selected
      started_at: $scope.start_time / 1000
      end_at: new Date / 1000

    finished.$save (data) ->
      $scope.data.finished.unshift finished
      $scope.data.current_selected = ''
      $scope.status = 'start'

app.controller 'FinishedCtrl', ($scope, Data, Finished) ->
  $scope.data = Data
  $scope.data.finished = Finished.query()

app.controller 'TodoCtrl', ($scope, Data, Todo) ->
  $scope.data = Data
  $scope.data.todos = Todo.query()
  $scope.add_todo = () ->
    newtodo = new Todo({content: $scope.newtodocontent, done: false})
    newtodo.$save (data) ->
      $scope.data.todos.unshift(newtodo)
      $scope.newtodocontent = ''

  $scope.update_todo = (todo) ->
    todo.$update()

  $scope.set_current_selected = (item) ->
    $scope.data.current_selected = item.content
