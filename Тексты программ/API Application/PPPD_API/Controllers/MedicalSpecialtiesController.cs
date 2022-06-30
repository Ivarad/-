using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PPPD_API.Models;

namespace PPPD_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MedicalSpecialtiesController : ControllerBase
    {
        private readonly PPPDContext _context;

        public MedicalSpecialtiesController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/MedicalSpecialties
        [HttpGet]
        public async Task<ActionResult<IEnumerable<MedicalSpecialtyGet>>> GetMedicalSpecialties()
        {
            var medicalSpecialities = await _context.MedicalSpecialties.ToListAsync();
            var list = new List<MedicalSpecialtyGet>();
            foreach (var speciality in medicalSpecialities)
            {
                list.Add(new MedicalSpecialtyGet
                {
                    employee = _context.Employees.First(e => e.IdEmployee == speciality.EmployeeId),
                    cabinet = _context.Cabinetns.First(e => e.EmployeeId == speciality.EmployeeId),
                    doctorSchedules = _context.DoctorSchedule.Where(e => e.SpecialityId == speciality.IdSpecialty).ToList(),
                    IdSpecialty = speciality.IdSpecialty,
                    EmployeeId = speciality.EmployeeId,
                    Specialty = speciality.Specialty,
                }) ; 
            }
            return list;
        }

        // GET: api/MedicalSpecialties/5
        [HttpGet("{id}")]
        public async Task<ActionResult<MedicalSpecialty>> GetMedicalSpecialty(int? id)
        {
            var medicalSpecialty = await _context.MedicalSpecialties.FindAsync(id);

            if (medicalSpecialty == null)
            {
                return NotFound();
            }

            return medicalSpecialty;
        }

        // PUT: api/MedicalSpecialties/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMedicalSpecialty(int? id, [FromBody] MedicalSpecialty medicalSpecialty)
        {
            if (id != medicalSpecialty.IdSpecialty)
            {
                return BadRequest();
            }

            _context.Entry(medicalSpecialty).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MedicalSpecialtyExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/MedicalSpecialties
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<MedicalSpecialty>> PostMedicalSpecialty([FromBody] MedicalSpecialty medicalSpecialty)
        {
            _context.MedicalSpecialties.Add(medicalSpecialty);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMedicalSpecialty", new { id = medicalSpecialty.IdSpecialty }, medicalSpecialty);
        }

        // DELETE: api/MedicalSpecialties/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<MedicalSpecialty>> DeleteMedicalSpecialty(int? id)
        {
            var medicalSpecialty = await _context.MedicalSpecialties.FindAsync(id);
            if (medicalSpecialty == null)
            {
                return NotFound();
            }

            _context.MedicalSpecialties.Remove(medicalSpecialty);
            await _context.SaveChangesAsync();

            return medicalSpecialty;
        }

        private bool MedicalSpecialtyExists(int? id)
        {
            return _context.MedicalSpecialties.Any(e => e.IdSpecialty == id);
        }
    }
}
