using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class MedicalSpecialty
    {
        public int? IdSpecialty { get; set; }
        public int EmployeeId { get; set; }
        public string Specialty { get; set; }
        
    }

    public partial class MedicalSpecialtyGet : MedicalSpecialty
    {
        public Employee employee { get; set; }
        public Cabinetn cabinet { get; set; }
        public IList<DoctorSchedule> doctorSchedules { get; set; }

    }
}
