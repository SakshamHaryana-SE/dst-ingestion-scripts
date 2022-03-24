const Excel = require('exceljs');
const {
  addIti,
  addTrainee,
  addIndustry,
  getIndustryByName,
  addIndustrySchedule
} = require('../utils');
const moment = require('moment');
const filename = 'Sample DST data.xlsx';
let trainees = [];
let industries = [];
let industrySchedule = [];
async function traineeStory() {
  const workbook = new Excel.Workbook();
  workbook.xlsx.readFile(filename)
    .then(async function () {

      // Industry
      // Get data for industry from xls
      const worksheetOfIndustry = workbook.getWorksheet(3);
      worksheetOfIndustry.eachRow(async function (row, rowNumber) {
        if(rowNumber >= 2) {
          const latLng = row.values[6].split(' ');
          let industryData = {};
          industryData.name = row.values[5];
          industryData.latitude = latLng[0];
          industryData.longitude = latLng[1];
          await industries.push(industryData);
        }
      });

      const industryPromiseAll = await industries.map(async (item) => {
        return new Promise(async (resolve) => {
          // If industry already add ten not add
          const industryRes = await getIndustryByName({ name: item.name })
          if(!industryRes.data.industry.length > 0) {
            // Add industry
            await addIndustry(item);
          }
          resolve(true)
        })
      })
      await Promise.all(industryPromiseAll);
      console.log(`Industry added: ${moment()}`);

      // Industry schedule
      // Get data for industry from xls
      const worksheetOfIndustrySchedule = workbook.getWorksheet(3);
      let columnData = [];

      worksheetOfIndustrySchedule.eachRow(async function (row, rowNumber) {
        if (rowNumber === 1) {
          columnData = row.values;
        }
        if (rowNumber >= 2) {
          // Get industry by name
          const industryRes = await getIndustryByName({name: row.values[5]})
          const batch = row.values[7].split('-');

          for (let column = 8; column < columnData.length; column++) {
            if (row.values[column] === 'Sessions ends') {
              break
            }
            // Prepare data of schedule
            const finalDate = moment(columnData[column]).format('YYYY-MM-DD').split('-');
            const scheduleData = {
              batch_start: batch[0],
              batch_end: `20${batch[1]}`,
              industry_id: industryRes.data.industry[0].id,
              month: finalDate[1],
              year: `20${finalDate[2]}`,
              is_industry: row.values[column] === 'Industry'
            }
           await industrySchedule.push(scheduleData);
          }
        }
      });

      // Add industry schedule
      setTimeout(async () => {
        const industrySchedulePromiseAll = await industrySchedule.map(async (schedule) => {
          return new Promise(async (resolve) => {

            // Add industry
            await addIndustrySchedule(schedule);

            resolve(true)
          })
        })
        await Promise.all(industrySchedulePromiseAll);
        console.log(`Industry schedule added: ${moment()}`);
      }, 200);

      // Trainee & ITI
      // Get data for trainee from xls
      const worksheet = workbook.getWorksheet(2);
      worksheet.eachRow(async function (row, rowNumber) {
        if (rowNumber >= 5) {
          let traineeData = {};
          traineeData.id = row.values[1];
          traineeData.itiname = row.values[2];
          traineeData.candidateName = row.values[8];
          traineeData.batch = row.values[5];
          traineeData.industry = row.values[6];
          traineeData.affiliationType = row.values[7];
          traineeData.registrationNumber = row.values[9];
          traineeData.DOB = row.values[15];
          traineeData.tradeName = row.values[3];
          traineeData.father = row.values[10];
          traineeData.mother = row.values[11];
          traineeData.gender = row.values[12];
          traineeData.dateOfAdmission = row.values[18];
         await trainees.push(traineeData);
        }
      });
      const traineePromiseAll = await trainees.map(async (item) => {
        return new Promise(async (resolve) => {
          // Add ITI
          const itiData = {
            latitude: 20.785961,
            longitude: 50.84163,
            name: item.itiname
          }
          addIti(itiData)
            .then(async (response) => {
              // Get industry by name
              const industryRes = await getIndustryByName({ name: item.industry })

              // Add trainee
              const itiResData = await (response.data)
              const traineeRequestData = {
                iti: itiResData.insert_iti.returning[0].id,
                DOB: moment(item.DOB),
                affiliationType: item.affiliationType,
                batch: item.batch,
                candidateName: item.candidateName,
                industry: industryRes.data.industry[0].id,
                registrationNumber: item.registrationNumber,
                tradeName: item.tradeName,
                father: item.father,
                mother: item.mother,
                gender: item.gender,
                dateOfAdmission: moment(item.dateOfAdmission)
              }
              await addTrainee(traineeRequestData)
            })
            .catch((e) => {
              console.log('e', e)
            })
          resolve(true)
        })
      })
      await Promise.all(traineePromiseAll);
      console.log(`Trainee added: ${moment()}`);
    });
}
traineeStory()
