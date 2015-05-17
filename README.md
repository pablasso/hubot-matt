# hubot-matt

Create a celebration matt meme

## Installation

In hubot project repo, run:

`npm install hubot-matt --save`

Then add **hubot-matt** to your `external-scripts.json`:

```json
[
  "hubot-matt"
]
```

## Usage

You need to have a memegenerator account and set this environment variables:

```
HUBOT_MEMEGEN_USERNAME
HUBOT_MEMEGEN_PASSWORD
```

| Command               | Description     
|-----------------------|----------------------------------------------------------------------
| `hubot matt me <text> | Generates the celebration matt meme with the bottom caption of <text>

For example:

```
user1>> hubot matt me something
hubot>> http://images.memegenerator.net/instances/62282118.jpg
```

