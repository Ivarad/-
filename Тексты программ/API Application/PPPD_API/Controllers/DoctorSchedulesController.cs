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
    public class DoctorSchedulesController : ControllerBase
    {
        private readonly PPPDContext _context;

        public DoctorSchedulesController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/DatesFirstRendereds
        [HttpGet]
        public async Task<ActionResult<IEnumerable<DoctorSchedule>>> GetDoctorSchedules()
        {
            return await _context.DoctorSchedule.ToListAsync();
        }

        // GET: api/DatesFirstRendereds/5
        [HttpGet("{id}")]
        public async Task<ActionResult<DoctorSchedule>> GetDoctorSchedule(int? id)
        {
            var doctorSchedule = await _context.DoctorSchedule.FindAsync(id);

            if (doctorSchedule == null)
            {
                return NotFound();
            }

            return doctorSchedule;
        }

        // PUT: api/DatesFirstRendereds/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDoctorSchedule(int? id, [FromBody] DoctorSchedule doctorSchedule)
        {
            if (id != doctorSchedule.SpecialityId)
            {
                return BadRequest();
            }

            _context.Entry(doctorSchedule).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DoctorScheduleExists(id))
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

        // POST: api/DatesFirstRendereds
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<DoctorSchedule>> PostDoctorSchedule([FromBody] DoctorSchedule doctorSchedule)
        {
            _context.DoctorSchedule.Add(doctorSchedule);

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (DoctorScheduleExists(doctorSchedule.SpecialityId))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetDoctorSchedule", new { id = doctorSchedule.SpecialityId }, doctorSchedule);
        }

        // DELETE: api/DatesFirstRendereds/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<DoctorSchedule>> DeleteDoctorSchedule(int? id)
        {
            var doctorSchedule = await _context.DoctorSchedule.FindAsync(id);
            if (doctorSchedule == null)
            {
                return NotFound();
            }

            _context.DoctorSchedule.Remove(doctorSchedule);
            await _context.SaveChangesAsync();

            return doctorSchedule;
        }

        private bool DoctorScheduleExists(int? id)
        {
            return _context.DoctorSchedule.Any(e => e.SpecialityId == id);
        }
    }
}
