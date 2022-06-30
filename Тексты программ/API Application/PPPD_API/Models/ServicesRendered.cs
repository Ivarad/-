using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class ServicesRendered
    {
        public int? IdServicesRendered { get; set; }
        public int DateFirstRenderedId { get; set; }
        public DateTime DateOfRendering { get; set; }
        public int BudgetTypeId { get; set; }
        public int PatientId { get; set; }
        public int EmployeeId { get; set; }
        public string Complaints { get; set; }
        public string Inspection { get; set; }
        public string Diagnosis { get; set; }
        public string Recommendations { get; set; }
        public int ScheduleId { get; set; }
        public bool? closed { get; set; }

    }
    [NotMapped]
    public partial class ServicesRenderedGet: ServicesRendered
    {
        
        public BudgetType budgetType { get; set; }
        
        public DatesFirstRendered datesFirstRendered { get; set; }
      
        public Patient patient { get; set; }
     
        public Employee employee { get; set; }
      
        public Schedule schedule { get; set; }
      
        public MedicalSpecialty medicalSpecialty { get; set; }
       
        public MedicalCard medicalCard { get; set; }
       
        public Cabinetn cabinet { get; set; }

       
    }
}
