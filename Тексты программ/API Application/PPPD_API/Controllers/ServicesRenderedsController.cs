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
    public class ServicesRenderedsController : ControllerBase
    {
        private readonly PPPDContext _context;

        public ServicesRenderedsController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/ServicesRendereds
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ServicesRenderedGet>>> GetServicesRendereds()
        {
            try
            {
                var servicesRendered = await _context.ServicesRendereds.ToListAsync();
                var list = new List<ServicesRenderedGet>();
                foreach (var appeal in servicesRendered)
                {
                    list.Add(new ServicesRenderedGet
                    {
                        budgetType = _context.BudgetTypes.FirstOrDefault(e => e.IdBudgetType == appeal.BudgetTypeId),
                        datesFirstRendered = _context.DatesFirstRendereds.FirstOrDefault(e => e.IdDateFirstRendered == appeal.DateFirstRenderedId),
                        patient = _context.Patients.FirstOrDefault(e => e.IdPatient == appeal.PatientId),
                        employee = _context.Employees.FirstOrDefault(e => e.IdEmployee == appeal.EmployeeId),
                        schedule = _context.Schedules.FirstOrDefault(e => e.IdSchedule == appeal.ScheduleId),
                        medicalSpecialty = _context.MedicalSpecialties.FirstOrDefault(e => e.EmployeeId == appeal.EmployeeId),
                        medicalCard = _context.MedicalCards.FirstOrDefault(e => e.IdMedicalCard == _context.Patients.FirstOrDefault(e => e.IdPatient == appeal.PatientId).MedicalCardId),
                        cabinet = _context.Cabinetns.FirstOrDefault(e => e.EmployeeId == appeal.EmployeeId),
                        IdServicesRendered = appeal.IdServicesRendered,
                        DateFirstRenderedId = appeal.DateFirstRenderedId,
                        DateOfRendering = appeal.DateOfRendering,
                        BudgetTypeId = appeal.BudgetTypeId,
                        PatientId = appeal.PatientId,
                        EmployeeId = appeal.EmployeeId,
                        Complaints = appeal.Complaints,
                        Inspection = appeal.Inspection,
                        Diagnosis = appeal.Diagnosis,
                        Recommendations = appeal.Recommendations,
                        ScheduleId = appeal.ScheduleId,
                        closed = appeal.closed,
                    });
                }
                return list;
            }
            catch (Exception e)
            {
                ServicesRenderedGet error = new ServicesRenderedGet();
                error.Complaints = e.Message;

                return new List<ServicesRenderedGet>() { error };
            }
           

        }

        // GET: api/ServicesRendereds/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ServicesRendered>> GetServicesRendered(int? id)
        {
            var servicesRendered = await _context.ServicesRendereds.FindAsync(id);

            if (servicesRendered == null)
            {
                return NotFound();
            }

            return servicesRendered;
        }

        // PUT: api/ServicesRendereds/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutServicesRendered(int? id, [FromBody] ServicesRendered servicesRendered)
        {
            if (id != servicesRendered.IdServicesRendered)
            {
                return BadRequest();
            }

            _context.Entry(servicesRendered).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ServicesRenderedExists(id))
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

        // POST: api/ServicesRendereds
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<ServicesRendered>> PostServicesRendered([FromBody] ServicesRendered servicesRendered)
        {
            _context.ServicesRendereds.Add(servicesRendered);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetServicesRendered", new { id = servicesRendered.IdServicesRendered }, servicesRendered);
        }

        // DELETE: api/ServicesRendereds/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<ServicesRendered>> DeleteServicesRendered(int? id)
        {
            var servicesRendered = await _context.ServicesRendereds.FindAsync(id);
            if (servicesRendered == null)
            {
                return NotFound();
            }

            _context.ServicesRendereds.Remove(servicesRendered);
            await _context.SaveChangesAsync();

            return servicesRendered;
        }

        private bool ServicesRenderedExists(int? id)
        {
            return _context.ServicesRendereds.Any(e => e.IdServicesRendered == id);
        }
    }
}
