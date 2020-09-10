# DEMO: Анализ проектов на уязвимости с помощью OneScript

Проект базируется на парсере исходного кода: osparser

## Как запустить

Ставим пакет из релиза:
```cmd
opm instal -f "path/to/ospx"
```

Запуск анализа:
```cmd
os-scanner analyze "path/to/src" "path/to/result"
```

пример:
```cmd
os-scanner analyze "project/src/cf" "./generic-issue.json"
```