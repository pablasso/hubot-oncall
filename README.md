# hubot-oncall

This project tells you who is oncall on the current week and automatically rotates given a defined roster.

The first version of this script was done by [Orlando Del Aguila](https://github.com/orlando).

## Installation

In hubot project repo, run:

`npm install hubot-oncall --save`

Then add **hubot-oncall** to your `external-scripts.json`:

```json
[
  "hubot-oncall"
]
```

## Usage

| Command                                                | Description     
|------------------------------------------------------------------------------------------------------------
| `hubot oncall set <person_a>,<person_b>,..,<person_N>` | Sets the list of persons to feed the oncall roster 
| `hubot oncall list`                                    | List the current roster of people available for oncall  
| `hubot oncall now`                                     | Returns who is oncall this week 
| `hubot oncall next`                                    | Returns who will be oncall next week  
| `hubot oncall last`                                    | Returns who was oncall last week

For example:

```
user1>> hubot oncall now
hubot>> pablasso is oncall
```

