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
    public class ProvidedAssistancesController : ControllerBase
    {
        private readonly PPPDContext _context;

        public ProvidedAssistancesController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/ProvidedAssistances
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProvidedAssistanceGet>>> GetProvidedAssistances()
        {
            var assistnances = await _context.ProvidedAssistances.ToListAsync();
            var list = new List<ProvidedAssistanceGet>();
            foreach (var assistance in assistnances)
            {
                list.Add(new ProvidedAssistanceGet
                {
                    services = _context.ServicesRendereds.FirstOrDefault(e => e.IdServicesRendered == assistance.ServicesRenderedId),
                    typeOfMedicalCare = _context.TypeOfMedicalCares.FirstOrDefault(e => e.IdTypeOfMedicalCare == assistance.TypeOfMedicalCareId),
                    service = _context.Services.FirstOrDefault(e => e.IdService == _context.TypeOfMedicalCares.FirstOrDefault(e => e.IdTypeOfMedicalCare == assistance.TypeOfMedicalCareId).ServiceId),
                    price = _context.Prices.FirstOrDefault(e => e.IdPrice == _context.Services.FirstOrDefault(e => e.IdService == _context.TypeOfMedicalCares.FirstOrDefault(e => e.IdTypeOfMedicalCare == assistance.TypeOfMedicalCareId).ServiceId).PriceId),
                    costsAndExpenses = _context.CostsAndExpenses.FirstOrDefault(e => e.IdCostsAndExpenses == _context.Services.FirstOrDefault(e => e.IdService == _context.TypeOfMedicalCares.FirstOrDefault(e => e.IdTypeOfMedicalCare == assistance.TypeOfMedicalCareId).ServiceId).CostsAndExpensesId),
                    speciality = _context.MedicalSpecialties.FirstOrDefault(e => e.IdSpecialty == _context.TypeOfMedicalCares.FirstOrDefault(e => e.IdTypeOfMedicalCare == assistance.TypeOfMedicalCareId).SpecialtyId),
                    TypeOfMedicalCareId = assistance.TypeOfMedicalCareId,
                    ServicesRenderedId = assistance.ServicesRenderedId,
                });
            }
            return list;
        }

        // GET: api/ProvidedAssistances/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProvidedAssistance>> GetProvidedAssistance(int? id)
        {
            var providedAssistance = await _context.ProvidedAssistances.FindAsync(id);

            if (providedAssistance == null)
            {
                return NotFound();
            }

            return providedAssistance;
        }

        // PUT: api/ProvidedAssistances/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProvidedAssistance(int? id, [FromBody] ProvidedAssistance providedAssistance)
        {
            if (id != providedAssistance.TypeOfMedicalCareId)
            {
                return BadRequest();
            }

            _context.Entry(providedAssistance).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProvidedAssistanceExists(id))
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

        // POST: api/ProvidedAssistances
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<ProvidedAssistance>> PostProvidedAssistance([FromBody] ProvidedAssistance providedAssistance)
        {
            _context.ProvidedAssistances.Add(providedAssistance);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (ProvidedAssistanceExists(providedAssistance.TypeOfMedicalCareId))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetProvidedAssistance", new { id = providedAssistance.TypeOfMedicalCareId }, providedAssistance);
        }

        // DELETE: api/ProvidedAssistances/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<ProvidedAssistance>> DeleteProvidedAssistance(int? id)
        {

            await _context.ProvidedAssistances.FromSqlRaw($"EXEC DeleteAssistances @providedId = {id};").ToListAsync();

            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProvidedAssistanceExists(int? id)
        {
            return _context.ProvidedAssistances.Any(e => e.TypeOfMedicalCareId == id);
        }
    }
}
