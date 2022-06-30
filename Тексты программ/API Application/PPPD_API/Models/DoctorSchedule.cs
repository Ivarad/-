using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

// Code scaffolded by EF Core assumes nullable reference types (NRTs) are not used or disabled.
// If you have enabled NRTs for your project, then un-comment the following line:
// #nullable disable

namespace PPPD_API.Models
{
    [Keyless]
    public partial class DoctorSchedule
    {
        public int? ScheduleId { get; set; }
        public int? SpecialityId { get; set; }


    }
}
