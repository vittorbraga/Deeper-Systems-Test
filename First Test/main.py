import json

with open('source_file_2.json') as file:
  data = json.load(file)

data = sorted(data, key=lambda k: k.get('priority', 0), reverse=False)

watchers = {}
managers = {}

for root in data:
    watcher = root["watchers"]
    for key in watcher:
        watchers.setdefault(key, []).append(root["name"])
    manager = root["managers"]
    for key in manager:
        managers.setdefault(key, []).append(root["name"])

# print(watchers)
# print(managers)

with open('watchers.json', 'w') as json_file:
  json.dump(watchers, json_file)

with open('managers.json', 'w') as json_file:
  json.dump(managers, json_file)