'use strict'

/** @type {import('@adonisjs/lucid/src/Schema')} */
const Schema = use('Schema')

class NoodleSchema extends Schema {
  up () {
    this.create('noodles', (table) => {
      table.increments()
      table.string('name')
      table.timestamps()
    })
  }

  down () {
    this.drop('noodles')
  }
}

module.exports = NoodleSchema
