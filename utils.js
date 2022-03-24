const axios = require('axios');
const {API_URL, HASURA_ADMIN_SECRET} = require('./config');
module.exports = {
  addTrainee: async function (data) {
    return axios({
      method: 'post',
      url: `${API_URL}/addTrainee`,
      data: JSON.stringify(data),
      headers: {
        'x-hasura-admin-secret': HASURA_ADMIN_SECRET,
        'Content-Type': 'application/json',
      }
    }).then((response) => {
      return response
    })
  },

  addIti: async function (data) {
    return axios({
      method: 'post',
      url: `${API_URL}/addIti`,
      data: JSON.stringify(data),
      headers: {
        'x-hasura-admin-secret': HASURA_ADMIN_SECRET,
        'Content-Type': 'application/json',
      }
    }).then((response) => {
     return response
    })
  },

  addIndustry: async function (data) {
      return axios({
        method: 'post',
        url: `${API_URL}/addIndustry`,
        data: JSON.stringify(data),
        headers: {
          'x-hasura-admin-secret': HASURA_ADMIN_SECRET,
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        return response
      })
  },

  getIndustryByName: async function (data) {
    return axios({
      method: 'get',
      url: `${API_URL}/getIndustryByName`,
      data: JSON.stringify(data),
      headers: {
        'x-hasura-admin-secret': HASURA_ADMIN_SECRET,
        'Content-Type': 'application/json',
      }
    }).then((response) => {
      return response
    })
  },

  addIndustrySchedule: async function (data) {
    return axios({
      method: 'post',
      url: `${API_URL}/addIndustrySchedule`,
      data: JSON.stringify(data),
      headers: {
        'x-hasura-admin-secret': HASURA_ADMIN_SECRET,
        'Content-Type': 'application/json',
      }
    }).then((response) => {
      return response
    })
  }
}


