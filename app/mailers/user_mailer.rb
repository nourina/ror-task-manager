class UserMailer < ApplicationMailer

  default from: 'taskmanager.innerhour@gmail.com'

  def reminder_email(task)
    @task_name = task.name
    @task_deadline = task.deadline
    @email = User.find(task.user_id).email

    mail(to: @email, subject: "Task Deadline Reminder #{@task_deadline}")
  end

end
