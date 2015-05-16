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
#   hubot oncall set <person_a>,<person_b>,..,<person_N> - Sets the list of persons to feed the oncall roster 
#   hubot oncall list - List the current roster of people available for oncall  
#   hubot oncall now - Returns who is oncall this week 
#   hubot oncall next - Returns who will be oncall next week  
#   hubot oncall last - Returns who was oncall last week
#
# Author:
#   Juan Pablo Ortiz

class OnCallRoster
  constructor: () ->
    @people = []
    @currentWeek = @getCurrentWeek()

  getCurrentWeek: () ->
    date = new Date
    onejan = new Date(date.getFullYear(), 0, 1)
    Math.ceil((((date - onejan) / 86400000) + onejan.getDay() + 1) / 7)

  getFirstDayWeek: (week) ->
    date = new Date
    onejan = new Date(date.getFullYear(), 0, 1)
    weekDate = onejan.getTime() + 604800000 * (week - 1)
    new Date(weekDate)

  getLastDayWeek: (week) ->
    date = new Date
    onejan = new Date(date.getFullYear(), 0, 1)
    weekDate = onejan.getTime() + 604800000 * (week - 1)
    new Date(weekDate + 518400000)

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
    msg.send('All set.')

  robot.respond /oncall list/, (msg) ->
    msg.send(onCallRoster.getPeopleList())

  robot.respond /oncall now/, (msg) ->
    if onCallRoster.getPeopleCount() == 0
      msg.reply("There's no people oncall. You can set them using the command <oncall set> with a comma separated list of people.")
      return

    currentWeek = onCallRoster.getCurrentWeek()
    oncall = onCallRoster.getOnCall(currentWeek)
    message = "#{oncall.person} is on call from #{oncall.startDate} to #{oncall.endDate}"
    msg.reply(message)

  robot.respond /oncall next/, (msg) ->
    if onCallRoster.getPeopleCount() == 0
      msg.reply("There's no people oncall. You can set them using the command <oncall set> with a comma separated list of people.")
      return

    msg.reply('Ok then.')

  robot.respond /oncall last/, (msg) ->
    if onCallRoster.getPeopleCount() == 0
      msg.reply("There's no people oncall. You can set them using the command <oncall set> with a comma separated list of people.")
      return
 
    msg.reply('Ok then.')
    
