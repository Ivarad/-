using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class Schedule
    {
        public int? IdSchedule { get; set; }
        public string Time { get; set; }
    }

    public partial class ScheduleGet : Schedule
    {
        public IList<DoctorSchedule> doctorSchedules { get; set; }
    }
}
