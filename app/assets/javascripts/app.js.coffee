app = angular.module('app', ['ngResource'])

app.directive 'empty', () ->
  (scope, element, attrs) ->
    element.bind('empty', () ->
      scope.$apply(attrs['empty'])
    )
    element.bind('keyup', () ->
      scope.$apply(attrs['empty'])
    )

unshift_new_task = (results, item) ->
  date = new Date item.updated_at
  date_s = date.format("%Y-%m-%d")
  finished = false
  for i, d of results
    if d[0] == date_s
      d[1].unshift item
      finished = true

app.factory 'Data', () ->
  finished = ['finished one', 'finished two']
  todos = [{content: '#todo task', done: true}]

  return {
    finished: finished,
    todos: todos,
    current_selected: '',
    duration: ''
  }

app.factory 'Alarm', () ->
  return document.getElementById('finish_alarm')

app.factory 'Todo', ($resource) ->
  $resource '/todos/:id', {id: '@id'},
    update: {method: 'PUT', params: {}}

app.factory 'Finished', ($resource) ->
  $resource '/finisheds/:id', {id: '@id'}, { query: { method: 'GET', params: {}, isArray: false } }

app.filter 'pomotime', () ->
  (text) ->
    sec = (100 + text % 60).toString().substr(1)
    min = (~~(text / 60) + 100).toString().substr(1)

    "#{min}:#{sec}"

app.controller 'TopCtrl', ($scope, Data) ->
  $scope.data = Data

app.controller 'ClockCtrl', ($scope, $timeout, Data, Alarm, Finished) ->
  $scope.data = Data
  prom = null
  $scope.status = 'start'
  $scope.data.duration = 0

  $scope.tick_start = () ->
    $scope.status = 'process'
    start_time = new Date()
    duration = 25 * 60000
    $scope.start_time = start_time
    $scope.expected_end_time = start_time + duration
    (tick = () ->
      passed = new Date - $scope.start_time
      if passed > duration
        $timeout.cancel(prom)
        $scope.data.duration = 0
        $scope.tick_end()
        return

      $scope.data.duration = ~~((duration - passed) / 1000)
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
      unshift_new_task $scope.data.finished.results, finished
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

  $scope.update_todo = (todo, index) ->
    if todo.content
      todo.$update()
    else
      todo.$remove () ->
        $scope.data.todos.splice(index, 1)

  $scope.set_current_selected = (item) ->
    $scope.data.current_selected = item.content
