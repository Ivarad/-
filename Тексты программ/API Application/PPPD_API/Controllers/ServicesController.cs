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
    public class ServicesController : ControllerBase
    {
        private readonly PPPDContext _context;

        public ServicesController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/Services
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ServiceGet>>> GetServices()
        {
            var services = await _context.Services.ToListAsync();
            var list = new List<ServiceGet>();
            foreach (var service in services)
            {
                list.Add(new ServiceGet
                {
                    price = _context.Prices.First(e => e.IdPrice == service.PriceId),
                    costsAndExpenses = _context.CostsAndExpenses.First(e => e.IdCostsAndExpenses == service.CostsAndExpensesId),
                    IdService = service.IdService,
                    Service1 = service.Service1,
                    PriceId = service.PriceId,
                    CostsAndExpensesId = service.CostsAndExpensesId,
                });
            }
            return list;
        }

        // GET: api/Services/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Service>> GetService(int? id)
        {
            var service = await _context.Services.FindAsync(id);

            if (service == null)
            {
                return NotFound();
            }

            return service;
        }

        // PUT: api/Services/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutService(int? id, [FromBody] Service service)
        {
            if (id != service.IdService)
            {
                return BadRequest();
            }

            _context.Entry(service).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ServiceExists(id))
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

        // POST: api/Services
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Service>> PostService([FromBody] Service service)
        {
            _context.Services.Add(service);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetService", new { id = service.IdService }, service);
        }

        // DELETE: api/Services/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Service>> DeleteService(int? id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null)
            {
                return NotFound();
            }

            _context.Services.Remove(service);
            await _context.SaveChangesAsync();

            return service;
        }

        private bool ServiceExists(int? id)
        {
            return _context.Services.Any(e => e.IdService == id);
        }
    }
}
