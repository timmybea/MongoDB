$(document).ready(function() {
  //alert('main is ready');

  getTasks();
  getCategories();
  getCategoryOptions();

  $('#add_task').on('submit', addTask);
  $('#edit_task').on('submit', editTask);

  $('body').on('click', '.btn-edit-task', setTask);
  $('body').on('click', '.btn-delete-task', deleteTask);

  $('#add_category').on('submit', addCategory);
  $('#edit_category').on('submit', editCategory);

  $('body').on('click', '.btn-edit-category', setCategory);
  $('body').on('click', '.btn-delete-category', deleteCategory);
});

//apiKey: in mLab, click on user and then scroll down to api key.
const apiKey = 'i80KEmnblwF6PPTw_T5QHtQGXFpU8cT_';

function getTasks() {
  $.get('https://api.mlab.com/api/1/databases/taskmanager/collections/tasks?apiKey='+apiKey, function(data) {
    console.log(data);
    let output = '<ul class="list-group">';
    $.each(data, function(key, task) {
      output += '<li class="list-group-item">';
      output += task.task_name+'<span class="due_on">[Due on '+task.due_date+']</span>';
      if (task.isUrgent == 'true') {
         output += '<span class="label label-danger">Urgent</span>';
      }
      output += '<div class="pull-right"><a class="btn btn-primary btn-edit-task" data-task-name="'+task.task_name+'" data-task-id="'+task._id.$oid+'" >Edit</a> <a class="btn btn-danger btn-delete-task" data-task-id="'+task._id.$oid+'">Delete</a></div></li>';
    }); //this is a loop
    output +='</ul>';
    $('#tasks').html(output);
  });
}

function getCategoryOptions() {
  $.get('https://api.mlab.com/api/1/databases/taskmanager/collections/categories?apiKey='+apiKey, function(data) {

    let output;

    $.each(data, function(key, category) {
      output += "<option value="+category.category_name+">"+category.category_name+"</option>"
    });
    $('#category').html(output);
  });
}

function addTask(event) {
  //get id task_name and pull value from it.
  const taskName = $('#task_name').val();
  const category = $('#category').val();
  const dueDate = $('#due_date').val();
  const urgent = $('#isUrgent').val();

  $.ajax({
    url : 'https://api.mlab.com/api/1/databases/taskmanager/collections/tasks?apiKey='+apiKey,
    data : JSON.stringify({
      "task_name" : taskName,
      "category" : category,
      "due_date" : dueDate,
      "isUrgent" : urgent
    }),
    type : 'POST',
    contentType : 'application/json',
    success : function(data) {
      window.location.href='index.html';
    },
    error : function(xhr, status, err) {
      console.log(err);
    }
  })
  event.preventDefault();
}

//Save a reference to the current task so that you can then get its info and update it.
function setTask() {
  console.log('set id to sessionStorage');
  var task_id = $(this).data('task-id');
  sessionStorage.setItem('current_id', task_id);
  window.location.href='edit_task.html';
  return false; //why???
}

function getTask(id) {
  //console.log('getTask called with id '+id);
  //https://api.mlab.com/api/1/databases/my-db/collections/my-coll?q={"active": true}&fo=true&apiKey=myAPIKey
  $.get('https://api.mlab.com/api/1/databases/taskmanager/collections/tasks/'+id+'?apiKey='+apiKey, function(data) {
    console.log(data);
    $('#task_name').val(data.task_name);
    $('#category').val(data.category);
    $('#due_date').val(data.due_date);
    $('#isUrgent').val(data.isUrgent);
  });
}

function editTask(event) {
  const task_id = sessionStorage.getItem('current_id')
  const taskName = $('#task_name').val();
  const category = $('#category').val();
  const dueDate = $('#due_date').val();
  const urgent = $('#isUrgent').val();

  $.ajax({
    url : 'https://api.mlab.com/api/1/databases/taskmanager/collections/tasks/'+task_id+'?apiKey='+apiKey,
    data : JSON.stringify({
      "task_name" : taskName,
      "category" : category,
      "due_date" : dueDate,
      "isUrgent" : urgent
    }),
    type : 'PUT',
    contentType : 'application/json',
    success : function(data) {
      window.location.href='index.html';
    },
    error : function(xhr, status, err) {
      console.log(err);
    }
  })
  event.preventDefault();
}

function deleteTask(event) {
  //console.log('delete task')
  var task_id = $(this).data('task-id');

  $.ajax({
    url : 'https://api.mlab.com/api/1/databases/taskmanager/collections/tasks/'+task_id+'?apiKey='+apiKey,
    type : 'DELETE',
    async: true,
    contentType : 'application/json',
    success : function(data) {
      window.location.href='index.html';
    },
    error : function(xhr, status, err) {
      console.log(err);
    }
  })

  event.preventDefault();
}

//CATEGORY FUNCTIONS
function getCategories() {
  $.get('https://api.mlab.com/api/1/databases/taskmanager/collections/categories?apiKey='+apiKey, function(data) {
    console.log(data);
    let output = '<ul class="list-group">';
    $.each(data, function(key, category) {
      output += '<li class="list-group-item">';
      output += category.category_name;
      output += '<div class="pull-right"><a class="btn btn-primary btn-edit-category" data-category-name="'+category.category_name+'" data-category-id="'+category._id.$oid+'" >Edit</a> <a class="btn btn-danger btn-delete-category" data-category-id="'+category._id.$oid+'">Delete</a></div></li>';
    }); //this is a loop
    output +='</ul>';
    $('#categories').html(output);
  });
}

function addCategory(event) {
  const categoryName = $('#category_name').val();

  $.ajax({
    url : 'https://api.mlab.com/api/1/databases/taskmanager/collections/categories?apiKey='+apiKey,
    data : JSON.stringify({
      "category_name" : categoryName
    }),
    type : 'POST',
    contentType : 'application/json',
    success : function(data) {
      window.location.href='categories.html';
    },
    error : function(xhr, status, err) {
      console.log(err);
    }
  })
  event.preventDefault();
}

function setCategory() {
  console.log('set id to sessionStorage');

  var category_id = $(this).data('category-id');
  sessionStorage.setItem('current_id', category_id);
  window.location.href='edit_category.html';
  return false; //why???
}

function getCategory(id) {

  $.get('https://api.mlab.com/api/1/databases/taskmanager/collections/categories/'+id+'?apiKey='+apiKey, function(data) {
    console.log(data);
    $('#category_name').val(data.category_name);
  });
}

function editCategory(event) {
  const category_id = sessionStorage.getItem('current_id')
  const categoryName = $('#category_name').val();

  $.ajax({
    url : 'https://api.mlab.com/api/1/databases/taskmanager/collections/categories/'+category_id+'?apiKey='+apiKey,
    data : JSON.stringify({
      "category_name" : categoryName
    }),
    type : 'PUT',
    contentType : 'application/json',
    success : function(data) {
      window.location.href='categories.html';
    },
    error : function(xhr, status, err) {
      console.log(err);
    }
  })
  event.preventDefault();
}

function deleteCategory(event) {
  //console.log('delete task')
  var category_id = $(this).data('category-id');

  $.ajax({
    url : 'https://api.mlab.com/api/1/databases/taskmanager/collections/categories/'+category_id+'?apiKey='+apiKey,
    type : 'DELETE',
    async: true,
    contentType : 'application/json',
    success : function(data) {
      window.location.href='categories.html';
    },
    error : function(xhr, status, err) {
      console.log(err);
    }
  })

  event.preventDefault();
}
