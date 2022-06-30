using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class TypeOfMedicalCare
    {
        public int? IdTypeOfMedicalCare { get; set; }
        public string TypeOfMedicalCare1 { get; set; }
        public int ServiceId { get; set; }
        public int SpecialtyId { get; set; }
    }

    public partial class TypeOfMedicalCareGet: TypeOfMedicalCare
    {
        public Service service { get; set; }
        public Price price { get; set; }
        public CostsAndExpense costsAndExpenses { get; set; }
        public MedicalSpecialty speciality { get; set; }
    }
}
