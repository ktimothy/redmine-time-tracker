## Вступление ##

Кто любит тормозной и уродливый интерфейс редмайна? Никто!

Кто любит трекать время каждый день? Никто!

Но, увы, трекать время надо...


Что же делать?


Трекать время из командной строки!


## Примеры использования ##

Получить список проектов, доступных текущему пользователю:
```
redmine --list_projects
```

По номеру проекта можно получить список задач:
```
redmine --list_tickets --project_id=XXX
redmine --list_tickets --project_id=XXX --with_status=accepted
```

Узнав номер задачи, можно затрекать в нее время:
```
redmine --track_time --to_issue=XXXXXX --spent=2.0 --on='краткий комментарий'
```

По умолчанию время будет затрекано за сегодняшний день, но можно указать любую другую дату:
```
redmine --track_time --to_issue=XXXXXX --spent=2.0 --on='краткий комментарий' --date=YYYY-MM-DD
```

И можно даже трекать удаленную работу:
```
redmine --track_time --to_issue=XXXXXX --spent=2.0 --on='краткий комментарий' --date=YYYY-MM-DD --remote
```

## Настройка ##

Переименовать config/redmine.yml.example -> config/redmine.yml и ввести свою связку логин-пароль.