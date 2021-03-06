USE [master]
GO
/****** Object:  Database [PPPD]    Script Date: 07.06.2022 18:09:26 ******/
CREATE DATABASE [PPPD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PPPD', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLFLEX\MSSQL\DATA\PPPD.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PPPD_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLFLEX\MSSQL\DATA\PPPD_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PPPD] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PPPD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PPPD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PPPD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PPPD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PPPD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PPPD] SET ARITHABORT OFF 
GO
ALTER DATABASE [PPPD] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [PPPD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PPPD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PPPD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PPPD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PPPD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PPPD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PPPD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PPPD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PPPD] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PPPD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PPPD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PPPD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PPPD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PPPD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PPPD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PPPD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PPPD] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PPPD] SET  MULTI_USER 
GO
ALTER DATABASE [PPPD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PPPD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PPPD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PPPD] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PPPD] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PPPD] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PPPD] SET QUERY_STORE = OFF
GO
USE [PPPD]
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[ID_Account] [int] IDENTITY(1,1) NOT NULL,
	[Login] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Email] [varchar](200) NOT NULL,
	[Role_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unqiueEmail] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unqiueLogin] UNIQUE NONCLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Budget_types]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Budget_types](
	[ID_Budget_type] [int] IDENTITY(1,1) NOT NULL,
	[Budget_type] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Budget_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cabinetns]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cabinetns](
	[ID_Cabinet] [int] IDENTITY(1,1) NOT NULL,
	[Employee_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Cabinet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Costs_and_expenses]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Costs_and_expenses](
	[ID_Costs_and_expenses] [int] IDENTITY(1,1) NOT NULL,
	[Costs] [decimal](15, 2) NOT NULL,
	[Expenses] [decimal](15, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Costs_and_expenses] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dates_first_rendered]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dates_first_rendered](
	[ID_Date_first_rendered] [int] IDENTITY(1,1) NOT NULL,
	[Date_first_renered] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Date_first_rendered] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor_Schedule]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor_Schedule](
	[Schedule_ID] [int] NOT NULL,
	[Speciality_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Schedule_ID] ASC,
	[Speciality_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[ID_Employee] [int] IDENTITY(1,1) NOT NULL,
	[Post_ID] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Patronymic] [varchar](100) NULL,
	[Surname] [varchar](100) NOT NULL,
	[Date_of_birth] [date] NOT NULL,
	[Account_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Employee] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gender](
	[ID_Gender] [int] IDENTITY(1,1) NOT NULL,
	[Gender] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Gender] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medical_card]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medical_card](
	[ID_Medical_card] [int] IDENTITY(1,1) NOT NULL,
	[Date_of_completion] [date] NOT NULL,
	[Surname] [varchar](100) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Patronymic] [varchar](100) NULL,
	[Date_of_birth] [date] NOT NULL,
	[Gender_ID] [int] NOT NULL,
	[CHI_policy] [bigint] NULL,
	[SNILS] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Medical_card] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medical_specialty]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medical_specialty](
	[ID_Specialty] [int] IDENTITY(1,1) NOT NULL,
	[Employee_ID] [int] NOT NULL,
	[Specialty] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Specialty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[ID_Patient] [int] IDENTITY(1,1) NOT NULL,
	[Account_ID] [int] NOT NULL,
	[Medical_card_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Patient] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Post]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[ID_Post] [int] IDENTITY(1,1) NOT NULL,
	[Post] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Post] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Price]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Price](
	[ID_Price] [int] IDENTITY(1,1) NOT NULL,
	[Price] [decimal](15, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Price] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provided_assistance]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Provided_assistance](
	[Type_of_medical_care_ID] [int] NOT NULL,
	[Services_rendered_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Referral]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Referral](
	[ID_Referral] [int] IDENTITY(1,1) NOT NULL,
	[Diagnosis] [varchar](300) NOT NULL,
	[Justification] [varchar](300) NOT NULL,
	[Date_of_create] [date] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Specialty_ID] [int] NOT NULL,
	[Service_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Referral] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[ID_Role] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Role] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedule](
	[ID_Schedule] [int] IDENTITY(1,1) NOT NULL,
	[Time] [varchar](8) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Schedule] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[ID_Service] [int] IDENTITY(1,1) NOT NULL,
	[Service] [varchar](100) NOT NULL,
	[Price_ID] [int] NOT NULL,
	[Costs_and_expenses_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Service] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services_rendered]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services_rendered](
	[ID_Services_rendered] [int] IDENTITY(1,1) NOT NULL,
	[Date_first_rendered_ID] [int] NOT NULL,
	[Date_of_rendering] [datetime] NOT NULL,
	[Budget_type_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Employee_ID] [int] NOT NULL,
	[Complaints] [varchar](300) NULL,
	[Inspection] [varchar](300) NULL,
	[Diagnosis] [varchar](300) NULL,
	[Recommendations] [varchar](300) NULL,
	[Schedule_ID] [int] NOT NULL,
	[Closed] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Services_rendered] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Type_of_medical_care]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Type_of_medical_care](
	[ID_Type_of_medical_care] [int] IDENTITY(1,1) NOT NULL,
	[Type_of_medical_care] [varchar](200) NOT NULL,
	[Service_ID] [int] NOT NULL,
	[Specialty_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Type_of_medical_care] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [FK_ID_Role] FOREIGN KEY([Role_ID])
REFERENCES [dbo].[Role] ([ID_Role])
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [FK_ID_Role]
GO
ALTER TABLE [dbo].[Cabinetns]  WITH CHECK ADD  CONSTRAINT [FK_ID_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([ID_Employee])
GO
ALTER TABLE [dbo].[Cabinetns] CHECK CONSTRAINT [FK_ID_Employee]
GO
ALTER TABLE [dbo].[Doctor_Schedule]  WITH CHECK ADD FOREIGN KEY([Schedule_ID])
REFERENCES [dbo].[Schedule] ([ID_Schedule])
GO
ALTER TABLE [dbo].[Doctor_Schedule]  WITH CHECK ADD FOREIGN KEY([Speciality_ID])
REFERENCES [dbo].[Medical_specialty] ([ID_Specialty])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_ID_Account] FOREIGN KEY([Account_ID])
REFERENCES [dbo].[Accounts] ([ID_Account])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_ID_Account]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_ID_Post] FOREIGN KEY([Post_ID])
REFERENCES [dbo].[Post] ([ID_Post])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_ID_Post]
GO
ALTER TABLE [dbo].[Medical_card]  WITH CHECK ADD  CONSTRAINT [FK_ID_Gender] FOREIGN KEY([Gender_ID])
REFERENCES [dbo].[Gender] ([ID_Gender])
GO
ALTER TABLE [dbo].[Medical_card] CHECK CONSTRAINT [FK_ID_Gender]
GO
ALTER TABLE [dbo].[Medical_specialty]  WITH CHECK ADD  CONSTRAINT [FK_ID_Employee_FOR_Medical_Specialty] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([ID_Employee])
GO
ALTER TABLE [dbo].[Medical_specialty] CHECK CONSTRAINT [FK_ID_Employee_FOR_Medical_Specialty]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_ID_Account_Patient] FOREIGN KEY([Account_ID])
REFERENCES [dbo].[Accounts] ([ID_Account])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_ID_Account_Patient]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_ID_Medical_card] FOREIGN KEY([Medical_card_ID])
REFERENCES [dbo].[Medical_card] ([ID_Medical_card])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_ID_Medical_card]
GO
ALTER TABLE [dbo].[Provided_assistance]  WITH CHECK ADD  CONSTRAINT [FK_ID_services_rendered] FOREIGN KEY([Services_rendered_ID])
REFERENCES [dbo].[Services_rendered] ([ID_Services_rendered])
GO
ALTER TABLE [dbo].[Provided_assistance] CHECK CONSTRAINT [FK_ID_services_rendered]
GO
ALTER TABLE [dbo].[Provided_assistance]  WITH CHECK ADD  CONSTRAINT [FK_ID_Type_of_medical_care] FOREIGN KEY([Type_of_medical_care_ID])
REFERENCES [dbo].[Type_of_medical_care] ([ID_Type_of_medical_care])
GO
ALTER TABLE [dbo].[Provided_assistance] CHECK CONSTRAINT [FK_ID_Type_of_medical_care]
GO
ALTER TABLE [dbo].[Referral]  WITH CHECK ADD  CONSTRAINT [FK_ID_Patient_Refferal] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([ID_Patient])
GO
ALTER TABLE [dbo].[Referral] CHECK CONSTRAINT [FK_ID_Patient_Refferal]
GO
ALTER TABLE [dbo].[Referral]  WITH CHECK ADD  CONSTRAINT [FK_ID_Service_Refferal] FOREIGN KEY([Service_ID])
REFERENCES [dbo].[Service] ([ID_Service])
GO
ALTER TABLE [dbo].[Referral] CHECK CONSTRAINT [FK_ID_Service_Refferal]
GO
ALTER TABLE [dbo].[Referral]  WITH CHECK ADD  CONSTRAINT [FK_ID_Specialty_Refferal] FOREIGN KEY([Specialty_ID])
REFERENCES [dbo].[Medical_specialty] ([ID_Specialty])
GO
ALTER TABLE [dbo].[Referral] CHECK CONSTRAINT [FK_ID_Specialty_Refferal]
GO
ALTER TABLE [dbo].[Service]  WITH CHECK ADD  CONSTRAINT [FK_ID_costs_and_expenses] FOREIGN KEY([Costs_and_expenses_ID])
REFERENCES [dbo].[Costs_and_expenses] ([ID_Costs_and_expenses])
GO
ALTER TABLE [dbo].[Service] CHECK CONSTRAINT [FK_ID_costs_and_expenses]
GO
ALTER TABLE [dbo].[Service]  WITH CHECK ADD  CONSTRAINT [FK_ID_Price] FOREIGN KEY([Price_ID])
REFERENCES [dbo].[Price] ([ID_Price])
GO
ALTER TABLE [dbo].[Service] CHECK CONSTRAINT [FK_ID_Price]
GO
ALTER TABLE [dbo].[Services_rendered]  WITH CHECK ADD  CONSTRAINT [FK_ID_budget_type] FOREIGN KEY([Budget_type_ID])
REFERENCES [dbo].[Budget_types] ([ID_Budget_type])
GO
ALTER TABLE [dbo].[Services_rendered] CHECK CONSTRAINT [FK_ID_budget_type]
GO
ALTER TABLE [dbo].[Services_rendered]  WITH CHECK ADD  CONSTRAINT [FK_ID_date_first_rendered] FOREIGN KEY([Date_first_rendered_ID])
REFERENCES [dbo].[Dates_first_rendered] ([ID_Date_first_rendered])
GO
ALTER TABLE [dbo].[Services_rendered] CHECK CONSTRAINT [FK_ID_date_first_rendered]
GO
ALTER TABLE [dbo].[Services_rendered]  WITH CHECK ADD  CONSTRAINT [FK_ID_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([ID_Patient])
GO
ALTER TABLE [dbo].[Services_rendered] CHECK CONSTRAINT [FK_ID_Patient]
GO
ALTER TABLE [dbo].[Services_rendered]  WITH CHECK ADD  CONSTRAINT [FK_ID_schedule] FOREIGN KEY([Schedule_ID])
REFERENCES [dbo].[Schedule] ([ID_Schedule])
GO
ALTER TABLE [dbo].[Services_rendered] CHECK CONSTRAINT [FK_ID_schedule]
GO
ALTER TABLE [dbo].[Type_of_medical_care]  WITH CHECK ADD  CONSTRAINT [FK_ID_Service] FOREIGN KEY([Service_ID])
REFERENCES [dbo].[Service] ([ID_Service])
GO
ALTER TABLE [dbo].[Type_of_medical_care] CHECK CONSTRAINT [FK_ID_Service]
GO
ALTER TABLE [dbo].[Type_of_medical_care]  WITH CHECK ADD  CONSTRAINT [FK_ID_Specialty] FOREIGN KEY([Specialty_ID])
REFERENCES [dbo].[Medical_specialty] ([ID_Specialty])
GO
ALTER TABLE [dbo].[Type_of_medical_care] CHECK CONSTRAINT [FK_ID_Specialty]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAssistances]    Script Date: 07.06.2022 18:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[DeleteAssistances]
@providedId int
AS 
Begin
delete from Provided_assistance where Services_rendered_ID = @providedId;
select * from Provided_assistance;
End
GO
USE [master]
GO
ALTER DATABASE [PPPD] SET  READ_WRITE 
GO
