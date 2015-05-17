# Description:
# This project tells you who is oncall on the current week and automatically rotates given a defined roster.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot oncall set <person1>,..,<personN> - Sets people for the oncall roster.
#   hubot oncall list - List the current roster available for oncall 
#   hubot oncall now - Returns who is oncall this week 
#   hubot oncall next - Returns who will be oncall next week 
#   hubot oncall last - Returns who was oncall last week.
#
# Author:
#   Juan Pablo Ortiz <pablasso@gmail.com>

class OnCallRoster
  constructor: () ->
    @people = []

  # 0 means current week, -1 means last week, 1 next week, and so on.
  getWeekNumber: (offset) ->
    offset = 7 * offset
    today = new Date
    date = new Date(today.getFullYear(), today.getMonth(), today.getDate() + offset)
    onejan = new Date(date.getFullYear(), 0, 1)
    Math.floor((((date - onejan) / 86400000) + onejan.getDay() + 1) / 7)

  getDayOfWeek: (weekNumber, dayNumber) ->
    year = (new Date).getFullYear()
    j10 = new Date(year, 0, 10, 12, 0, 0)
    j4 = new Date(year, 0, 4, 12, 0, 0)
    mon1 = j4.getTime() - j10.getDay() * 86400000
    new Date(mon1 + ((weekNumber - 1) * 7 + dayNumber) * 86400000)

  getOnCall: (week) ->
    person: @people[week % @people.length]
    startDate: @getPrettyDate(@getDayOfWeek(week, 0))
    endDate: @getPrettyDate(@getDayOfWeek(week, 7))

  getPeopleCount: () ->
    @people.length

  getPeopleList: () ->
    @people.join(',')

  setPeopleList: (list) ->
    @people = list.split(',')

  getPrettyDate: (date) ->
    "#{date.getMonth() + 1}/#{date.getDate()}"

module.exports = (robot) ->
  onCallRoster = new OnCallRoster()

  robot.respond /oncall set (.*)/i, (msg) ->
    onCallRoster.setPeopleList(msg.match[1])
    msg.send("All set. I don't persist data though so please save the list yourself in case I reboot.")

  robot.respond /oncall list/, (msg) ->
    if onCallRoster.getPeopleCount() == 0
      msg.send("There's no people oncall. You can set them using the command <oncall set> with a comma separated list of people.")
      return

    msg.send(onCallRoster.getPeopleList())

  robot.respond /oncall (now|next|last)/, (msg) ->
    if onCallRoster.getPeopleCount() == 0
      msg.send("There's no people oncall. You can set them using the command <oncall set> with a comma separated list of people.")
      return

    if msg.match[1] == 'now'
      week_offset = 0
      week_verb = 'is'
    else if msg.match[1] == 'next'
      week_offset = 1
      week_verb = 'will be'
    else if msg.match[1] == 'last'
      week_offset = -1
      week_verb = 'was'

    week = onCallRoster.getWeekNumber(week_offset)
    oncall = onCallRoster.getOnCall(week)
    message = "#{oncall.person} #{week_verb} on call from #{oncall.startDate} to #{oncall.endDate}" 
    msg.reply(message) 
