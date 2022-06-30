using System;
using System.Collections.Generic;

#nullable disable

namespace PPPD_API.Models
{
    public partial class Referral
    {
        public int? IdReferral { get; set; }
        public string Diagnosis { get; set; }
        public string Justification { get; set; }
        public DateTime DateOfCreate { get; set; }
        public int PatientId { get; set; }
        public int SpecialtyId { get; set; }
        public int ServiceId { get; set; }
    }
}
