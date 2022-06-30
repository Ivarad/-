using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace PPPD_API.Models
{
    public partial class PPPDContext : DbContext
    {
        public PPPDContext()
        {
        }

        public PPPDContext(DbContextOptions<PPPDContext> options)
            : base(options)
        {
        }
        public virtual DbSet<Account> Accounts { get; set; }
        public virtual DbSet<BudgetType> BudgetTypes { get; set; }
        public virtual DbSet<Cabinetn> Cabinetns { get; set; }
        public virtual DbSet<CostsAndExpense> CostsAndExpenses { get; set; }
        public virtual DbSet<DatesFirstRendered> DatesFirstRendereds { get; set; }
        public virtual DbSet<DoctorSchedule> DoctorSchedule { get; set; }
        public virtual DbSet<Employee> Employees { get; set; }
        public virtual DbSet<Gender> Genders { get; set; }
        public virtual DbSet<MedicalCard> MedicalCards { get; set; }
        public virtual DbSet<MedicalSpecialty> MedicalSpecialties { get; set; }
        public virtual DbSet<Patient> Patients { get; set; }
        public virtual DbSet<Post> Posts { get; set; }
        public virtual DbSet<Price> Prices { get; set; }
        public virtual DbSet<ProvidedAssistance> ProvidedAssistances { get; set; }
        public virtual DbSet<Referral> Referrals { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Schedule> Schedules { get; set; }
        public virtual DbSet<Service> Services { get; set; }
        public virtual DbSet<ServicesRendered> ServicesRendereds { get; set; }
        public virtual DbSet<TypeOfMedicalCare> TypeOfMedicalCares { get; set; }



        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "Cyrillic_General_CI_AS");

            modelBuilder.Entity<Account>(entity =>
            {
                entity.HasKey(e => e.IdAccount)
                    .HasName("PK__Accounts__213379EB99B4224C");

                entity.Property(e => e.IdAccount)
                    
                    .HasColumnName("ID_Account");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.Login)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RoleId).HasColumnName("Role_ID");

            });

            modelBuilder.Entity<BudgetType>(entity =>
            {
                entity.HasKey(e => e.IdBudgetType)
                    .HasName("PK__Budget_t__C6355C7770E1D37F");

                entity.ToTable("Budget_types");

                entity.Property(e => e.IdBudgetType).HasColumnName("ID_Budget_type");

                entity.Property(e => e.BudgetType1)
                    .IsRequired()
                    .HasMaxLength(200)
                    .IsUnicode(false)
                    .HasColumnName("Budget_type");
            });

            modelBuilder.Entity<Cabinetn>(entity =>
            {
                entity.HasKey(e => e.IdCabinet)
                    .HasName("PK__Cabinetn__5484AEF048780435");

                entity.Property(e => e.IdCabinet).HasColumnName("ID_Cabinet");

                entity.Property(e => e.EmployeeId).HasColumnName("Employee_ID");

            });

            modelBuilder.Entity<CostsAndExpense>(entity =>
            {
                entity.HasKey(e => e.IdCostsAndExpenses)
                    .HasName("PK__Costs_an__E7FD2633B8240B02");

                entity.ToTable("Costs_and_expenses");

                entity.Property(e => e.IdCostsAndExpenses).HasColumnName("ID_Costs_and_expenses");

                entity.Property(e => e.Costs).HasColumnType("decimal(15, 2)");

                entity.Property(e => e.Expenses).HasColumnType("decimal(15, 2)");
            });

            modelBuilder.Entity<DatesFirstRendered>(entity =>
            {
                entity.HasKey(e => e.IdDateFirstRendered)
                    .HasName("PK__Dates_fi__788815C8D0101C8D");

                entity.ToTable("Dates_first_rendered");

                entity.Property(e => e.IdDateFirstRendered).HasColumnName("ID_Date_first_rendered");

                entity.Property(e => e.DateFirstRenered)
                    .HasColumnType("date")
                    .HasColumnName("Date_first_renered");
            });
            modelBuilder.Entity<DoctorSchedule>(entity =>
            {
                entity.HasKey(e => new { e.ScheduleId, e.SpecialityId })
                    .HasName("PK__Doctor_S__5C77BA52F1D1CB85");
                //entity<DoctorSchedule>.OwnsOne(e => e.)

                entity.ToTable("Doctor_Schedule");

                entity.Property(e => e.ScheduleId).HasColumnName("Schedule_ID");

                entity.Property(e => e.SpecialityId).HasColumnName("Speciality_ID");

            });
            modelBuilder.Entity<Employee>(entity =>
            {
                entity.HasKey(e => e.IdEmployee)
                    .HasName("PK__Employee__D9EE4F3617E99143");

                entity.ToTable("Employee");

                entity.Property(e => e.IdEmployee).HasColumnName("ID_Employee");

                entity.Property(e => e.AccountId).HasColumnName("Account_ID");

                entity.Property(e => e.DateOfBirth)
                    .HasColumnType("date")
                    .HasColumnName("Date_of_birth");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Patronymic)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.PostId).HasColumnName("Post_ID");

                entity.Property(e => e.Surname)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

            });

            modelBuilder.Entity<Gender>(entity =>
            {
                entity.HasKey(e => e.IdGender)
                    .HasName("PK__Gender__52B1A3A190CCAA2D");

                entity.ToTable("Gender");

                entity.Property(e => e.IdGender).HasColumnName("ID_Gender");

                entity.Property(e => e.Gender1)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("Gender");
            });

            modelBuilder.Entity<MedicalCard>(entity =>
            {
                entity.HasKey(e => e.IdMedicalCard)
                    .HasName("PK__Medical___7A0413BA016401D7");

                entity.ToTable("Medical_card");

                entity.Property(e => e.IdMedicalCard).HasColumnName("ID_Medical_card");

                entity.Property(e => e.ChiPolicy).HasColumnName("CHI_policy");

                entity.Property(e => e.DateOfBirth)
                    .HasColumnType("date")
                    .HasColumnName("Date_of_birth");

                entity.Property(e => e.DateOfCompletion)
                    .HasColumnType("date")
                    .HasColumnName("Date_of_completion");

                entity.Property(e => e.GenderId).HasColumnName("Gender_ID");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Patronymic)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Snils).HasColumnName("SNILS");

                entity.Property(e => e.Surname)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

            });

            modelBuilder.Entity<MedicalSpecialty>(entity =>
            {
                entity.HasKey(e => e.IdSpecialty)
                    .HasName("PK__Medical___0BE09D936EB5A573");

                entity.ToTable("Medical_specialty");

                entity.Property(e => e.IdSpecialty).HasColumnName("ID_Specialty");

                entity.Property(e => e.EmployeeId).HasColumnName("Employee_ID");

                entity.Property(e => e.Specialty)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

            });

            modelBuilder.Entity<Patient>(entity =>
            {
                entity.HasKey(e => e.IdPatient)
                    .HasName("PK__Patient__EE3EFF68C502078C");

                entity.ToTable("Patient");

                entity.Property(e => e.IdPatient).HasColumnName("ID_Patient");

                entity.Property(e => e.AccountId).HasColumnName("Account_ID");

                entity.Property(e => e.MedicalCardId).HasColumnName("Medical_card_ID");

            });

            modelBuilder.Entity<Post>(entity =>
            {
                entity.HasKey(e => e.IdPost)
                    .HasName("PK__Post__B41D0E307CDB77B9");

                entity.ToTable("Post");

                entity.Property(e => e.IdPost).HasColumnName("ID_Post");

                entity.Property(e => e.Post1)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("Post");
            });

            modelBuilder.Entity<Price>(entity =>
            {
                entity.HasKey(e => e.IdPrice)
                    .HasName("PK__Price__61E3790DE559E34B");

                entity.ToTable("Price");

                entity.Property(e => e.IdPrice).HasColumnName("ID_Price");

                entity.Property(e => e.Price1)
                    .HasColumnType("decimal(15, 2)")
                    .HasColumnName("Price");
            });

            modelBuilder.Entity<ProvidedAssistance>(entity =>
            {
                entity.HasKey(e => new { e.TypeOfMedicalCareId, e.ServicesRenderedId })
                    .HasName("PK__Provided__F3E71BE4A18DF37D");

                entity.ToTable("Provided_assistance");

                entity.Property(e => e.TypeOfMedicalCareId).HasColumnName("Type_of_medical_care_ID");

                entity.Property(e => e.ServicesRenderedId).HasColumnName("Services_rendered_ID");

            });




            modelBuilder.Entity<Referral>(entity =>
            {
                entity.HasKey(e => e.IdReferral)
                    .HasName("PK__Referral__A74DE5553D8244D9");

                entity.ToTable("Referral");

                entity.Property(e => e.IdReferral).HasColumnName("ID_Referral");

                entity.Property(e => e.DateOfCreate)
                    .HasColumnType("date")
                    .HasColumnName("Date_of_create");

                entity.Property(e => e.Diagnosis)
                    .IsRequired()
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.Justification)
                    .IsRequired()
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.PatientId).HasColumnName("Patient_ID");

                entity.Property(e => e.ServiceId).HasColumnName("Service_ID");

                entity.Property(e => e.SpecialtyId).HasColumnName("Specialty_ID");
            });

            modelBuilder.Entity<Role>(entity =>
            {
                entity.HasKey(e => e.IdRole)
                    .HasName("PK__Role__43DCD32D94C5FE09");

                entity.ToTable("Role");

                entity.Property(e => e.IdRole).HasColumnName("ID_Role");

                entity.Property(e => e.Role1)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("Role");
            });

            modelBuilder.Entity<Schedule>(entity =>
            {
                entity.HasKey(e => e.IdSchedule)
                    .HasName("PK__Schedule__73616218FE39A3EF");

                entity.ToTable("Schedule");

                entity.Property(e => e.IdSchedule).HasColumnName("ID_Schedule");
            });

            modelBuilder.Entity<Service>(entity =>
            {
                entity.HasKey(e => e.IdService)
                    .HasName("PK__Service__8C3D4AEFE0BB99D1");

                entity.ToTable("Service");

                entity.Property(e => e.IdService).HasColumnName("ID_Service");

                entity.Property(e => e.CostsAndExpensesId).HasColumnName("Costs_and_expenses_ID");

                entity.Property(e => e.PriceId).HasColumnName("Price_ID");

                entity.Property(e => e.Service1)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("Service");
            });

            modelBuilder.Entity<ServicesRendered>(entity =>
            {
                entity.HasKey(e => e.IdServicesRendered)
                    .HasName("PK__Services__7B4CADF27D40808D");

                entity.ToTable("Services_rendered");

                entity.Property(e => e.IdServicesRendered).HasColumnName("ID_Services_rendered");

                entity.Property(e => e.BudgetTypeId).HasColumnName("Budget_type_ID");


                entity.Property(e => e.Complaints)

                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.DateFirstRenderedId).HasColumnName("Date_first_rendered_ID");


                entity.Property(e => e.DateOfRendering)
                    .HasColumnType("datetime")
                    .HasColumnName("Date_of_rendering");

                entity.Property(e => e.Diagnosis)

                    .HasMaxLength(300)
                    .IsUnicode(false);


                entity.Property(e => e.EmployeeId).HasColumnName("Employee_ID");

                entity.Property(e => e.Inspection)

                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.PatientId).HasColumnName("Patient_ID");

                entity.Property(e => e.Recommendations)

                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.ScheduleId).HasColumnName("Schedule_ID");


            });

            modelBuilder.Entity<TypeOfMedicalCare>(entity =>
            {
                entity.HasKey(e => e.IdTypeOfMedicalCare)
                    .HasName("PK__Type_of___C453D13BF214CC91");

                entity.ToTable("Type_of_medical_care");

                entity.Property(e => e.IdTypeOfMedicalCare).HasColumnName("ID_Type_of_medical_care");

                entity.Property(e => e.ServiceId).HasColumnName("Service_ID");

                entity.Property(e => e.SpecialtyId).HasColumnName("Specialty_ID");

                entity.Property(e => e.TypeOfMedicalCare1)
                    .IsRequired()
                    .HasMaxLength(200)
                    .IsUnicode(false)
                    .HasColumnName("Type_of_medical_care");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
