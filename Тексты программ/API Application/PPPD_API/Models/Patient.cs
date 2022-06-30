using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class Patient
    {
        public int? IdPatient { get; set; }
        public int AccountId { get; set; }
        public int MedicalCardId { get; set; }
    }

    public partial class PatientGet : Patient
    {
        public MedicalCard medicalCard { get; set; }

    }
}
