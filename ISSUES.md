# This page is to bring all the issues I faced and how I worked it out

## 1: Permission denied

When I tried to run `docker-compose run app sh -c "django-admin startproject app ."` I got the following error:
`"PermissionError: [Errno 13] Permission denied: '/app/manage.py"`. After some research I found that the problem was with
the djangouser permissions, so I had to run `docker-compose run --rm app sh -c "chown djangouser:djangouser -R /app/"` in
terminal to fix it. After that I was able to run the command without any problem.

## 2: External Interpreter


This one was tricky. In this course the instructor said that although there are many benefits from using docker, the drawbkack
is that we'll lose the ability to have linting since the IDE (he was using VS Code, I use PyCharm) does not have access to the
Python interpreter inside the container. I tried to find a solution for this and I found that PyCharm actually supports
Docker in a way that it can introspect the container and access the interpreter. I tried to do this, but it was kinda broke.


It was not recognizing the dependencies correctly and I was not able to have the code checking. After searching for a while
I found [this comment](https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000373944/comments/13025094358290)
that fixed the problem to me. Basically it says that I should add the /tmp directory to docker desktop file sharing. Note:
I'm using Ubuntu 22.04 LTS. I don't know if this is a problem with other OSs.
